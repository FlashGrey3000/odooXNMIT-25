from sqlalchemy import Column, Integer, String, Text, Enum, ForeignKey, Date, TIMESTAMP, func
from sqlalchemy.orm import relationship
from database import Base
import enum

# ---------------------------
# Task Status Enum
# ---------------------------
class TaskStatus(str, enum.Enum):
    todo = "To-Do"
    in_progress = "In Progress"
    done = "Done"

# ---------------------------
# Users
# ---------------------------
class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    password_hash = Column(String(255), nullable=False)
    created_at = Column(TIMESTAMP, server_default=func.current_timestamp())

    # Relationships
    created_projects = relationship("Project", back_populates="creator", cascade="all, delete")
    assigned_tasks = relationship("Task", back_populates="assignee", foreign_keys="Task.assignee_id")
    memberships = relationship("ProjectMember", back_populates="user", cascade="all, delete")

# ---------------------------
# Projects
# ---------------------------
class Project(Base):
    __tablename__ = "projects"

    project_id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(200), nullable=False)
    description = Column(Text)
    created_by = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False)
    created_at = Column(TIMESTAMP, server_default=func.current_timestamp())

    # Relationships
    creator = relationship("User", back_populates="created_projects")
    tasks = relationship("Task", back_populates="project", cascade="all, delete")
    members = relationship("ProjectMember", back_populates="project", cascade="all, delete")

# ---------------------------
# Project Members (Many-to-Many)
# ---------------------------
class ProjectMember(Base):
    __tablename__ = "project_members"

    project_id = Column(Integer, ForeignKey("projects.project_id", ondelete="CASCADE"), primary_key=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), primary_key=True)
    role = Column(Enum("member", "admin", "owner", name="role_enum"), default="member")

    # Relationships
    user = relationship("User", back_populates="memberships")
    project = relationship("Project", back_populates="members")

# ---------------------------
# Tasks
# ---------------------------
class Task(Base):
    __tablename__ = "tasks"

    task_id = Column(Integer, primary_key=True, autoincrement=True)
    project_id = Column(Integer, ForeignKey("projects.project_id", ondelete="CASCADE"), nullable=False)
    title = Column(String(200), nullable=False)
    description = Column(Text)
    assignee_id = Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL"), nullable=True)
    status = Column(Enum(TaskStatus), default=TaskStatus.todo)
    due_date = Column(Date, nullable=True)
    created_at = Column(TIMESTAMP, server_default=func.current_timestamp())

    # Relationships
    project = relationship("Project", back_populates="tasks")
    assignee = relationship("User", back_populates="assigned_tasks", foreign_keys=[assignee_id])
