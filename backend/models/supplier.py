from sqlalchemy import Column, Integer, String
from backend.database import Base


class Supplier(Base):

    __tablename__ = "suppliers"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String)

    phone = Column(String)

    address = Column(String)

    gst_number = Column(String)