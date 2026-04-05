from fastapi import APIRouter
import shutil
import datetime
import os

router = APIRouter()

DATABASE_FILE = "pharmacy.db"
BACKUP_FOLDER = "backups"


@router.get("/backup")
def create_backup():

    if not os.path.exists(BACKUP_FOLDER):
        os.makedirs(BACKUP_FOLDER)

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

    backup_file = f"{BACKUP_FOLDER}/backup_{timestamp}.db"

    shutil.copy(DATABASE_FILE, backup_file)

    return {
        "message": "Backup created",
        "file": backup_file
    }