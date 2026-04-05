from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.sale import Sale
from backend.models.medicine import Medicine
import datetime
import json

router = APIRouter()


@router.post("/sale")
def create_sale(data: dict):

    db = SessionLocal()

    items = data.get("items", [])

    total = 0

    for item in items:

        medicine = db.query(Medicine).filter(Medicine.id == item["id"]).first()

        if not medicine:
            continue

        qty = int(item["quantity"])

        # Reduce stock
        medicine.quantity = medicine.quantity - qty

        total += medicine.selling_price * qty

    sale = Sale(
        total=total,
        date=str(datetime.datetime.now()),
        items=json.dumps(items)
    )

    db.add(sale)

    db.commit()

    return {
        "message": "Sale completed",
        "total": total
    }