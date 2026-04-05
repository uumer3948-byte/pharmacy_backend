from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.medicine import Medicine

router = APIRouter()


@router.get("/medicines")
def get_medicines():

    db = SessionLocal()

    medicines = db.query(Medicine).all()

    result = []

    for m in medicines:
        result.append({
            "id": m.id,
            "name": m.name,
            "quantity": m.quantity,
            "selling_price": m.selling_price,
            "expiry_date": m.expiry_date
        })

    return result


@router.post("/medicines")
def add_medicine(data: dict):

    db = SessionLocal()

    medicine = Medicine(
        name=data.get("name"),
        quantity=data.get("quantity"),
        selling_price=data.get("selling_price"),
        expiry_date=data.get("expiry_date")
    )

    db.add(medicine)
    db.commit()

    return {"message": "Medicine added"}


@router.delete("/medicines/{id}")
def delete_medicine(id: int):

    db = SessionLocal()

    med = db.query(Medicine).filter(Medicine.id == id).first()

    if med:
        db.delete(med)
        db.commit()

    return {"message": "Deleted"}