from sqlalchemy.orm import Session
from models import User, Project, Task
import models
from schemas import UserCreate, ProjectCreate, TaskCreate
from passlib.context import CryptContext

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
def create_project(db: Session, project: ProjectCreate, user_id: int):
    db_project = Project(name=project.name, description=project.description, created_by=user_id)
    db.add(db_project)
    db.commit()
    db.refresh(db_project)
    return db_project

# Tasks
def create_task(db: Session, task: TaskCreate):
    db_task = Task(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

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
