from sqlalchemy import Column, Integer, String
from backend.database import Base


class MedicineOrder(Base):

    __tablename__ = "medicine_orders"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)