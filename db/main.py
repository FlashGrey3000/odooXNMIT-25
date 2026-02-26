from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.security import OAuth2PasswordBearer
from auth import create_access_token,verify_token
from database import Base, engine, get_db
import crud, schemas, models
from fastapi.middleware.cors import CORSMiddleware

# Create tables if they don't exist
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="SynergySphere API",
    description="""
    Project Collaboration Backend

    Features:
    - User Authentication (JWT)
    - Project Management
    - Role-Based Access Control
    - Task Management
    """,
    version="1.0.0",
    docs_url="/docs",        # Swagger UI
    redoc_url="/redoc",      # ReDoc UI
    openapi_url="/openapi.json"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# Register User
@app.post("/signup/", response_model=schemas.UserOut)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db, user)


# Login User
@app.post("/login")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = crud.get_user_by_email(db, form_data.username)
    if not user or not crud.pwd_context.verify(form_data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Incorrect email or password")
    
    token = create_access_token({"sub": user.email})  # encode email (or user_id)
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "user_id": user.user_id,
            "name": user.name,
            "email": user.email
        }
    }

# To view profile of logged in User
@app.get("/users/me", response_model=schemas.UserOut)
def get_current_user(user: schemas.UserOut = Depends(verify_token)):
    return user

# Get User by User ID
@app.get("/users/{user_id}", response_model=schemas.UserOut)
def get_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    db_user = crud.get_user_by_id(db, user_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Allow only self-view or admin/owner
    if current_user.user_id != user_id:
        # Check if current_user is admin/owner in any project with this user
        shared_projects = (
            db.query(models.ProjectMember)
            .join(models.Project)
            .filter(
                models.ProjectMember.user_id == current_user.user_id,
                models.ProjectMember.role.in_(["owner", "admin"]),
                models.ProjectMember.project_id.in_(
                    db.query(models.ProjectMember.project_id)
                    .filter(models.ProjectMember.user_id == user_id)
                )
            )
            .all()
        )
        if not shared_projects:
            raise HTTPException(status_code=403, detail="Not authorized to view this user")

    return db_user



@app.post("/projects/", response_model=schemas.ProjectOut)
def add_project(
    project: schemas.ProjectCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    return crud.create_project(db, project, current_user.user_id)



# Adding members to project
@app.post("/projects/{project_id}/members/")
def add_member(
    project_id: int,
    member_data: schemas.ProjectMemberCreate,  # includes user_id + role
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    # Check if current user is owner or admin
    membership = crud.get_project_membership(db, project_id, current_user.user_id)
    if not membership or membership.role not in ["owner", "admin"]:
        raise HTTPException(status_code=403, detail="Not authorized to add members")

    # Validate role input
    if member_data.role not in ["member", "admin"]:
        raise HTTPException(status_code=400, detail="Invalid role. Use 'member' or 'admin'.")

    return crud.add_member_to_project(db, project_id, member_data.user_id, member_data.role)



# Fetch Project Details by Project ID
@app.get("/projects/{project_id}", response_model=schemas.ProjectOut)
def get_project(
    project_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    db_project = crud.get_project_by_id(db, project_id)
    if not db_project:
        raise HTTPException(status_code=404, detail="Project not found")

    # Only allow users who are members/admins/owners
    membership = crud.get_project_membership(db, project_id, current_user.user_id)
    if not membership:
        raise HTTPException(status_code=403, detail="Not authorized to view this project")

    return db_project



# Update Project Details
@app.put("/projects/{project_id}/update", response_model=schemas.ProjectOut)
def update_project(
    project_id: int,
    updated_project: schemas.ProjectUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    # check if user is owner/admin
    membership = crud.get_project_membership(db, project_id, current_user.user_id)
    if not membership or membership.role not in ["owner", "admin"]:
        raise HTTPException(status_code=403, detail="Not authorized to update this project")

    db_project = crud.get_project_by_id(db, project_id)
    if not db_project:
        raise HTTPException(status_code=404, detail="Project not found")

    return crud.update_project(db, db_project, updated_project)



# List all projects a user is part of OR 
# List all projects a specific user is part of (only for owners/admins of that project)
@app.get("/users/{user_id}/projects", response_model=list[schemas.ProjectOut])
def get_user_projects(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    # Get all projects where current_user is admin or owner
    memberships = (
        db.query(models.ProjectMember)
        .filter(
            models.ProjectMember.user_id == current_user.user_id,
            models.ProjectMember.role.in_(["owner", "admin"])
        )
        .all()
    )

    allowed_project_ids = [m.project_id for m in memberships]

    # Check if the requested user has projects in allowed projects
    projects = (
        db.query(models.Project)
        .join(models.ProjectMember)
        .filter(
            models.ProjectMember.user_id == user_id,
            models.ProjectMember.project_id.in_(allowed_project_ids)
        )
        .all()
    )
    return projects


# Create task
@app.post("/tasks/", response_model=schemas.TaskOut)
def add_task(
    task: schemas.TaskCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    # Check if user is part of the project
    membership = crud.get_project_membership(db, task.project_id, current_user.user_id)
    if not membership:
        raise HTTPException(status_code=403, detail="You are not part of this project")

    # If member, they can only assign tasks to themselves
    if membership.role == "member":
        if task.assignee_id is None or task.assignee_id != current_user.user_id:
            raise HTTPException(
                status_code=403,
                detail="Members can only assign tasks to themselves"
            )
    else:  # admin or owner
        # Optional: ensure assignee is part of the same project
        assignee_membership = crud.get_project_membership(db, task.project_id, task.assignee_id)
        if task.assignee_id and not assignee_membership:
            raise HTTPException(
                status_code=400,
                detail="Assignee must be a member of the project"
            )

    return crud.create_task(db, task)


# Update a task (only admin/owner can update)
@app.put("/tasks/{task_id}/update", response_model=schemas.TaskOut)
def update_task(
    task_id: int,
    updated_task: schemas.TaskUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    db_task = db.query(models.Task).filter(models.Task.task_id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail="Task not found")

    # Check if current_user is admin or owner of the project
    membership = crud.get_project_membership(db, db_task.project_id, current_user.user_id)
    if not membership or membership.role not in ["owner", "admin"]:
        raise HTTPException(status_code=403, detail="Not authorized to update this task")

    return crud.update_task(db, db_task, updated_task)


# Delete a task (only admin/owner can delete)
@app.delete("/tasks/{task_id}/delete")
def delete_task(
    task_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    db_task = db.query(models.Task).filter(models.Task.task_id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail="Task not found")

    # Check if current_user is admin or owner of the project
    membership = crud.get_project_membership(db, db_task.project_id, current_user.user_id)
    if not membership or membership.role not in ["owner", "admin"]:
        raise HTTPException(status_code=403, detail="Not authorized to delete this task")

    return crud.delete_task(db, db_task)




# Get all tasks assigned to a user OR
# Get all tasks assigned to a specific user (only for owners/admins who manage those projects)
@app.get("/users/{user_id}/tasks", response_model=list[schemas.TaskOut])
def get_user_tasks(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    # Get all projects where current_user is owner/admin
    memberships = (
        db.query(models.ProjectMember)
        .filter(
            models.ProjectMember.user_id == current_user.user_id,
            models.ProjectMember.role.in_(["owner", "admin"])
        )
        .all()
    )

    allowed_project_ids = [m.project_id for m in memberships]

    # Return only tasks in projects where current_user has admin/owner role
    tasks = (
        db.query(models.Task)
        .filter(
            models.Task.assignee_id == user_id,
            models.Task.project_id.in_(allowed_project_ids)
        )
        .all()
    )
    return tasks



# Get task by project ID
@app.get("/projects/{project_id}/tasks/", response_model=list[schemas.TaskOut])
def get_tasks_for_project(
    project_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    membership = crud.get_project_membership(db, project_id, current_user.user_id)
    if not membership:
        raise HTTPException(status_code=403, detail="Not authorized to view tasks")

    return db.query(models.Task).filter(models.Task.project_id == project_id).all()
