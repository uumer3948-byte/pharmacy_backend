from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.database import SessionLocal
from backend.models.supplier import Supplier

router = APIRouter()


def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()


@router.post("/suppliers")
def add_supplier(data: dict, db: Session = Depends(get_db)):

    supplier = Supplier(
        name=data.get("name"),
        phone=data.get("phone"),
        address=data.get("address"),
        gst_number=data.get("gst_number")
    )

    db.add(supplier)

    db.commit()

    db.refresh(supplier)

    return supplier


@router.get("/suppliers")
def get_suppliers(db: Session = Depends(get_db)):

    return db.query(Supplier).all()