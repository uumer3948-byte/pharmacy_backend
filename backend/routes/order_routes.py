from fastapi import APIRouter
from sqlalchemy.orm import Session

from backend.database import SessionLocal
from backend.models.order import MedicineOrder


router = APIRouter()


# ADD MEDICINE TO ORDER LIST

@router.post("/order-medicine")

def order_medicine(data: dict):

    db: Session = SessionLocal()

    med = MedicineOrder(name=data["name"])

    db.add(med)
    db.commit()

    return {"message": "medicine added to order list"}



# GET ORDER LIST

@router.get("/order-medicines")

def get_orders():

    db: Session = SessionLocal()

    orders = db.query(MedicineOrder).all()

    return orders