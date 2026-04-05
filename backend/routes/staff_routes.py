from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.user import User

router = APIRouter()


@router.post("/staff/register")
def register_staff(data: dict):

    db = SessionLocal()

    user = User(
        username=data.get("username"),
        password=data.get("password"),
        role=data.get("role")
    )

    db.add(user)
    db.commit()

    return {"message": "Staff created"}


@router.post("/staff/login")
def login_staff(data: dict):

    db = SessionLocal()

    user = db.query(User).filter(User.username == data.get("username")).first()

    if not user or user.password != data.get("password"):
        return {"error": "Invalid credentials"}

    return {
        "message": "Login successful",
        "user_id": user.id,
        "role": user.role
    }