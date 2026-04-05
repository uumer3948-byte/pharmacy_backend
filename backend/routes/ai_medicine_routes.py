from fastapi import APIRouter, UploadFile, File
import pytesseract
import cv2
import numpy as np

router = APIRouter()

pytesseract.pytesseract.tesseract_cmd = "/opt/homebrew/bin/tesseract"

@router.post("/detect-medicine")

async def detect_medicine(file: UploadFile = File(...)):

    contents = await file.read()

    nparr = np.frombuffer(contents, np.uint8)

    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    text = pytesseract.image_to_string(gray)

    return {"detected": text.lower()}