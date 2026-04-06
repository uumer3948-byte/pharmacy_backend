from fastapi import APIRouter, UploadFile, File
import google.generativeai as genai
import os
from PIL import Image
import io

router = APIRouter()

# Setup Gemini
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-1.5-flash')

@router.post("/scan")
async def scan_medicine(file: UploadFile = File(...)):
    # 1. Read the image from the mobile app
    img_data = await file.read()
    img = Image.open(io.BytesIO(img_data))

    # 2. Ask Gemini to extract the professional data
    prompt = """
    Look at this medicine image. Extract:
    1. Medicine Name
    2. Manufacturing Date (MFG)
    3. Expiry Date (EXP)
    Return the result in a clean JSON format.
    """
    
    response = model.generate_content([prompt, img])
    
    # 3. Return the AI results to your Flutter app
    return {"data": response.text}