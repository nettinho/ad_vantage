import json

from celery.result import AsyncResult
from fastapi import Body, FastAPI, Form, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from worker import create_task
from services.validator import Validator


app = FastAPI()

@app.get("/healthcheck")
def healthcheck():
    return JSONResponse({"status": "🚀"})


@app.post("/validate")
def validate(payload = Body(...)):
    url_master = payload["url_master"]
    url_variation = payload["url_variation"]
    return Validator().validate_variation(url_master, url_variation)


@app.post("/tasks", status_code=201)
def run_task(payload = Body(...)):
    task_type = payload["type"]
    task = create_task.delay(int(task_type))
    return JSONResponse({"task_id": task.id})


@app.get("/tasks/{task_id}")
def get_status(task_id):
    task_result = AsyncResult(task_id)
    result = {
        "task_id": task_id,
        "task_status": task_result.status,
        "task_result": task_result.result
    }
    return JSONResponse(result)
