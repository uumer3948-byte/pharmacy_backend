from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.customer import Customer

router = APIRouter()


@router.post("/customers")
def add_customer(data: dict):

    db = SessionLocal()

    customer = Customer(
        name=data.get("name"),
        phone=data.get("phone")
    )

    db.add(customer)

    db.commit()

    db.refresh(customer)

    return {"message": "Customer added"}


@router.get("/customers")
def get_customers():

    db = SessionLocal()

    customers = db.query(Customer).all()

    return customers