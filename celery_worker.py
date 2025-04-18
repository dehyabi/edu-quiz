from app import create_app
from celery import Celery
import os

flask_app = create_app()

celery = Celery(__name__, broker=os.getenv("CELERY_BROKER"))
celery.conf.update(flask_app.config)