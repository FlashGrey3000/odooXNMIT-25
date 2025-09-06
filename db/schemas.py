from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date
from models import TaskStatus

# User schemas
class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserOut(BaseModel):
    user_id: int
    name: str
    email: EmailStr
    class Config:
        orm_mode = True

# Project schemas
class ProjectCreate(BaseModel):
    name: str
    description: Optional[str] = None

class ProjectOut(BaseModel):
    project_id: int
    name: str
    description: Optional[str]
    class Config:
        orm_mode = True

# Task schemas
class TaskCreate(BaseModel):
    project_id: int
    title: str
    description: Optional[str] = None
    assignee_id: Optional[int] = None
    status: Optional[TaskStatus] = TaskStatus.todo
    due_date: Optional[date] = None

class TaskOut(BaseModel):
    task_id: int
    title: str
    status: TaskStatus
    class Config:
        orm_mode = True

class ProjectMemberCreate(BaseModel):
    project_id: int
    user_id: int
    role: Optional[str] = "member"

class ProjectMemberOut(BaseModel):
    project_id: int
    user_id: int
    role: str
    class Config:
        orm_mode = True

class Token(BaseModel):
    access_token: str
    token_type: str


class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None  # will be hashed in CRUD


# --- Project update ---
class ProjectUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None


# --- Task update ---
class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    assignee_id: Optional[int] = None
    status: Optional[str] = None
    due_date: Optional[str] = None  # ISO date string
