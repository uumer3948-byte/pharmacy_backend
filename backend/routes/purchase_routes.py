from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.database import SessionLocal
from backend.models.purchase import Purchase
from backend.models.medicine import Medicine
from datetime import datetime

router = APIRouter()


def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()


@router.post("/purchase")
def create_purchase(data: dict, db: Session = Depends(get_db)):

    medicine = db.query(Medicine).filter(
        Medicine.id == data.get("medicine_id")
    ).first()

    if not medicine:
        return {"error": "Medicine not found"}

    medicine.quantity += data.get("quantity")

    purchase = Purchase(
        medicine_id=data.get("medicine_id"),
        supplier_id=data.get("supplier_id"),
        quantity=data.get("quantity"),
        purchase_price=data.get("purchase_price"),
        invoice_number=data.get("invoice_number"),
        date=str(datetime.now())
    )

    db.add(purchase)

    db.commit()

    return {"message": "Purchase recorded and stock updated"}