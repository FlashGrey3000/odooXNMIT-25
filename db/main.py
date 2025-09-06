from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import Base, engine, get_db
import crud, schemas, models

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="SynergySphere MVP")

# Create user
@app.post("/users/", response_model=schemas.UserOut)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db, user)

# Create project
@app.post("/projects/", response_model=schemas.ProjectOut)
def add_project(project: schemas.ProjectCreate, user_id: int, db: Session = Depends(get_db)):
    return crud.create_project(db, project, user_id)

# Create task
@app.post("/tasks/", response_model=schemas.TaskOut)
def add_task(task: schemas.TaskCreate, db: Session = Depends(get_db)):
    return crud.create_task(db, task)
