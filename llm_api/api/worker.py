import os
import json
import time

from celery import Celery


celery = Celery(__name__)
celery.conf.broker_url = os.environ.get("CELERY_BROKER_URL", "redis://localhost:6379")
celery.conf.result_backend = os.environ.get("CELERY_RESULT_BACKEND", "redis://localhost:6379")


@celery.task(name="create_task", autoretry_for=(Exception,), retry_backoff=True, retry_kwargs={'max_retries': 3})
def create_task(task_type):
    time.sleep(int(task_type) * 10)
    return True
