from sqlalchemy import Column, Integer, String, Float
from backend.database import Base


class Medicine(Base):

    __tablename__ = "medicines"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String, nullable=False)

    quantity = Column(Integer, default=0)

    selling_price = Column(Float, default=0)

    expiry_date = Column(String)   # format: YYYY-MM-DD