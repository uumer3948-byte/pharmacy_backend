from sqlalchemy import Column, Integer, Float, String
from backend.database import Base


class Sale(Base):

    __tablename__ = "sales"

    id = Column(Integer, primary_key=True, index=True)

    total = Column(Float)

    date = Column(String)

    customer_id = Column(Integer)   # NEW

    items = Column(String)          # store JSON as string