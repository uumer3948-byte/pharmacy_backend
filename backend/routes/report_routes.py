from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.sale import Sale
from datetime import date

router = APIRouter()

@router.get("/report")
def report():

    db = SessionLocal()

    sales = db.query(Sale).all()

    today = str(date.today())

    today_revenue = sum(s.total for s in sales if str(s.date).startswith(today))

    return {
        "today_revenue": today_revenue
    }