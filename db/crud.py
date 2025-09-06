from sqlalchemy.orm import Session
from models import User, Project, Task
import models
from schemas import UserCreate, ProjectCreate, TaskCreate
import schemas
from passlib.context import CryptContext
from fastapi import HTTPException

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Users
def create_user(db: Session, user: UserCreate):
    hashed_password = pwd_context.hash(user.password)
    db_user = User(name=user.name, email=user.email, password_hash=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

# Projects
def create_project(db: Session, project: schemas.ProjectCreate, user_id: int):
    db_project = models.Project(
        name=project.name,
        description=project.description,
        created_by=user_id
    )
    db.add(db_project)
    db.commit()
    db.refresh(db_project)

    # Add creator as owner in project_members
    db_member = models.ProjectMember(
        project_id=db_project.project_id,
        user_id=user_id,
        role="owner"
    )
    db.add(db_member)
    db.commit()

    return db_project

# Tasks
def create_task(db: Session, task: TaskCreate):
    db_task = Task(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

def update_project(db, db_project, updated_project):
    if updated_project.name:
        db_project.name = updated_project.name
    if updated_project.description:
        db_project.description = updated_project.description
    db.commit()
    db.refresh(db_project)
    return db_project


def get_project_membership(db, project_id, user_id):
    return (
        db.query(models.ProjectMember)
        .filter(
            models.ProjectMember.project_id == project_id,
            models.ProjectMember.user_id == user_id,
        )
        .first()
    )


def add_member_to_project(db, project_id, user_id, role="member"):
    # check if user is already a member
    existing = get_project_membership(db, project_id, user_id)
    if existing:
        raise HTTPException(status_code=400, detail="User already a member of this project")

    new_member = models.ProjectMember(
        project_id=project_id,
        user_id=user_id,
        role=role
    )
    db.add(new_member)
    db.commit()
    db.refresh(new_member)
    return new_member


def get_user_by_id(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.user_id == user_id).first()


def get_project_by_id(db: Session, project_id: int):
    return db.query(models.Project).filter(models.Project.project_id == project_id).first()

def get_tasks_by_project(db: Session, project_id: int):
    return db.query(models.Task).filter(models.Task.project_id == project_id).all()

def get_projects_by_user(db: Session, user_id: int):
    return (
        db.query(models.Project)
        .join(models.ProjectMember)
        .filter(models.ProjectMember.user_id == user_id)
        .all()
    )


def get_tasks_by_user(db: Session, user_id: int):
    return db.query(models.Task).filter(models.Task.assignee_id == user_id).all()


def update_task(db, db_task, updated_task):
    if updated_task.title:
        db_task.title = updated_task.title
    if updated_task.description:
        db_task.description = updated_task.description
    if updated_task.assignee_id:
        db_task.assignee_id = updated_task.assignee_id
    db.commit()
    db.refresh(db_task)
    return db_task

def delete_task(db, db_task):
    db.delete(db_task)
    db.commit()
    return {"detail": "Task deleted successfully"}

