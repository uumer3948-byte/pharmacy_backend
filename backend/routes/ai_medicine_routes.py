from fastapi import APIRouter, UploadFile, File, HTTPException
from google import genai
from google.genai import types
import os
import io
from PIL import Image

router = APIRouter()

# Setup Gemini Client (Professional Version)
# Make sure GEMINI_API_KEY is set in your Render Environment Variables
client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

@router.post("/detect-medicine")
async def detect_medicine(file: UploadFile = File(...)):
    try:
        # 1. Read the image from the mobile app
        contents = await file.read()
        
        # 2. Convert bytes to a PIL Image (Standard for professional Python apps)
        image = Image.open(io.BytesIO(contents))

        # 3. Use Gemini 1.5 Flash (Fast and accurate for OCR)
        prompt = """
        Extract the following from this medicine image:
        - Medicine Name
        - Manufacturing Date (MFG)
        - Expiry Date (EXP)
        Return the result in a clean JSON format. 
        If you cannot find a field, return 'Unknown'.
        """
        
        # 4. Generate content using the new 'google-genai' library
        response = client.models.generate_content(
            model="gemini-1.5-flash",
            contents=[prompt, image]
        )
        
        # 5. Return the AI results to your Flutter app
        return {
            "success": True,
            "detected": response.text.strip()
        }

    except Exception as e:
        # Professional error handling
        raise HTTPException(status_code=500, detail=f"AI Processing failed: {str(e)}")