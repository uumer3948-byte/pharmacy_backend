from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.sale import Sale
import json

router = APIRouter()

@router.get("/history/{customer_id}")
def get_history(customer_id: int):

    db = SessionLocal()

    sales = db.query(Sale).filter(Sale.customer_id == customer_id).all()

    result = []

    for s in sales:

        result.append({
            "date": s.date,
            "items": json.loads(s.items)
        })

    return result