from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.database import SessionLocal
from backend.models.user import User
from backend.utils.auth import hash_password, verify_password, create_token

router = APIRouter()


def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()


@router.post("/register")
def register(data: dict, db: Session = Depends(get_db)):

    user = User(
        username=data.get("username"),
        password=hash_password(data.get("password")),
        role=data.get("role")
    )

    db.add(user)

    db.commit()

    db.refresh(user)

    return {"message": "User created"}


@router.post("/login")
def login(data: dict, db: Session = Depends(get_db)):

    user = db.query(User).filter(
        User.username == data.get("username")
    ).first()

    if not user:
        return {"error": "User not found"}

    if not verify_password(data.get("password"), user.password):
        return {"error": "Invalid password"}

    token = create_token(user.username)

    return {
        "token": token,
        "role": user.role
    }