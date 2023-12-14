import pytest


def test_healthchek(test_app):
    response = test_app.get("/healthcheck")
    assert response.status_code == 200
    assert response.json() == {"status": "🚀"}


def test_validate(test_app):
    body = {
        "url_master": "",
        "url_variation": ""
    }
    response = test_app.post("/validate", json=body)
    assert response.status_code == 200
    assert "validate" in response.json().keys()