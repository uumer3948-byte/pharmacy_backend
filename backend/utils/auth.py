from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta

SECRET_KEY = "pharmacy_secret_key"

ALGORITHM = "HS256"

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password):

    return pwd_context.hash(password)


def verify_password(plain, hashed):

    return pwd_context.verify(plain, hashed)


def create_token(username):

    payload = {
        "sub": username,
        "exp": datetime.utcnow() + timedelta(hours=10)
    }

    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

    return token