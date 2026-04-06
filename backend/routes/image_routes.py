from fastapi import APIRouter, UploadFile, File, HTTPException
from google import genai  # This is the new library
import os
from PIL import Image
import io

router = APIRouter()

# 1. Create the Client (Professional way)
# Make sure GEMINI_API_KEY is in your Render Environment tab
client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

@router.post("/scan")
async def scan_medicine(file: UploadFile = File(...)):
    try:
        # 2. Read the image
        img_data = await file.read()
        img = Image.open(io.BytesIO(img_data))

        # 3. Use the client to generate content
        response = client.models.generate_content(
            model="gemini-1.5-flash",
            contents=["Extract Medicine Name, MFG Date, and EXP Date as JSON.", img]
        )
        
        return {"data": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))