import pytest
from django.conf import settings
from rest_framework.test import APIClient

pytestmark = pytest.mark.django_db(databases=["default"])


def test_content_project_has_no_auth_app():
    assert "django.contrib.auth" not in settings.INSTALLED_APPS
    assert "django.contrib.sessions" not in settings.INSTALLED_APPS


def test_anonymous_api_get_renders_html():
    response = APIClient().get("/api/brands/", HTTP_ACCEPT="text/html")
    assert response.status_code == 200
