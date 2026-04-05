from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from backend.database import Base, engine

# Import Models
from backend.models.medicine import Medicine
from backend.models.sale import Sale
from backend.models.supplier import Supplier
from backend.models.purchase import Purchase
from backend.models.user import User
from backend.models.customer import Customer

# Import Routes
from backend.routes.medicine_routes import router as medicine_router
from backend.routes.billing_routes import router as billing_router
from backend.routes.supplier_routes import router as supplier_router
from backend.routes.purchase_routes import router as purchase_router
from backend.routes.auth_routes import router as auth_router
from backend.routes.dashboard_routes import router as dashboard_router
from backend.routes.report_routes import router as report_router
from backend.routes.customer_routes import router as customer_router
from backend.routes.history_routes import router as history_router
from backend.routes.staff_routes import router as staff_router
from backend.routes.backup_routes import router as backup_router
from backend.routes.image_routes import router as image_router
from backend.routes.ai_medicine_routes import router as ai_router
from backend.routes.order_routes import router as order_router


app = FastAPI(title="Pharmacy Management System")


# Allow Frontend Access (CORS)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Create database tables

Base.metadata.create_all(bind=engine)


# Serve frontend pages

app.mount(
    "/frontend",
    StaticFiles(directory="frontend"),
    name="frontend"
)


# Serve invoices folder

app.mount(
    "/invoices",
    StaticFiles(directory="invoices"),
    name="invoices"
)


# Register API routes

app.include_router(auth_router)
app.include_router(medicine_router)
app.include_router(billing_router)
app.include_router(supplier_router)
app.include_router(purchase_router)
app.include_router(dashboard_router)
app.include_router(report_router)
app.include_router(customer_router)
app.include_router(history_router)
app.include_router(staff_router)
app.include_router(backup_router)
app.include_router(image_router)
app.include_router(ai_router)
app.include_router(order_router)

@app.get("/")
def root():
    return {"message": "Pharmacy API running successfully"}