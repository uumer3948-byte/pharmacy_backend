from sqlalchemy import Column, Integer, String
from backend.database import Base


class Purchase(Base):

    __tablename__ = "purchases"

    id = Column(Integer, primary_key=True, index=True)

    medicine_id = Column(Integer)

    supplier_id = Column(Integer)

    quantity = Column(Integer)

    purchase_price = Column(Integer)

    invoice_number = Column(String)

    date = Column(String)