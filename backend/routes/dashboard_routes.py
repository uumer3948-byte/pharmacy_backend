from fastapi import APIRouter
from backend.database import SessionLocal
from backend.models.medicine import Medicine
from backend.models.sale import Sale
from datetime import datetime, timedelta

router = APIRouter()


@router.get("/dashboard")
def dashboard():

    db = SessionLocal()

    medicines = db.query(Medicine).all()
    sales = db.query(Sale).all()

    total_sales = sum(s.total for s in sales)

    low_stock = [m.name for m in medicines if m.quantity < 10]

    expiring = []

    today = datetime.today()

    for m in medicines:
        try:
            expiry = datetime.strptime(m.expiry_date, "%Y-%m-%d")
            if expiry < today + timedelta(days=30):
                expiring.append(m.name)
        except:
            pass

    return {
        "today_sales": total_sales,
        "total_medicines": len(medicines),
        "low_stock": low_stock,
        "expiring": expiring
    }