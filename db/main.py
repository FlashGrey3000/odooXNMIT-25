from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.security import OAuth2PasswordBearer
from auth import create_access_token,verify_token
from database import Base, engine, get_db
import crud, schemas, models, json
from fastapi.middleware.cors import CORSMiddleware

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="SynergySphere MVP")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For development; in production, restrict to your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# Create user
@app.post("/signup/", response_model=schemas.UserOut)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db, user)



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


@app.get("/users/me", response_model=schemas.UserOut)
def get_current_user(user: schemas.UserOut = Depends(verify_token)):
    return user


@app.get("/users/{user_id}", response_model=schemas.UserOut)
def get_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_id(db, user_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


# Create project
@app.post("/projects/", response_model=schemas.ProjectOut)
def add_project(project: schemas.ProjectCreate, user_id: int, db: Session = Depends(get_db)):
    return crud.create_project(db, project, user_id)

# Create task
@app.post("/tasks/", response_model=schemas.TaskOut)
def add_task(task: schemas.TaskCreate, db: Session = Depends(get_db)):
    return crud.create_task(db, task)

@app.get("/projects/{project_id}", response_model=schemas.ProjectOut)
def get_project(project_id: int, db: Session = Depends(get_db)):
    db_project = crud.get_project_by_id(db, project_id)
    if not db_project:
        raise HTTPException(status_code=404, detail="Project not found")
    return db_project


@app.get("/projects/{project_id}/tasks/", response_model=list[schemas.TaskOut])
def get_tasks_for_project(project_id: int, db: Session = Depends(get_db)):
    tasks = db.query(models.Task).filter(models.Task.project_id == project_id).all()
    return tasks

@app.get("/users/{user_id}/projects/", response_model=list[schemas.ProjectOut])
def get_user_projects(user_id: int, db: Session = Depends(get_db)):
    projects = (
        db.query(models.Project)
        .join(models.ProjectMember)
        .filter(models.ProjectMember.user_id == user_id)
        .all()
    )
    return projects

@app.get("/users/{user_id}/tasks/", response_model=list[schemas.TaskOut])
def get_user_tasks(user_id: int, db: Session = Depends(get_db)):
    return crud.get_tasks_by_user(db, user_id)
