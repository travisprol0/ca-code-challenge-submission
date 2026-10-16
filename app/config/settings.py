import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = "dev-scaffold-not-for-production"
DEBUG = True
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.contenttypes",
    "django.contrib.staticfiles",
    "rest_framework",
    "content",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"
WSGI_APPLICATION = "config.wsgi.application"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {"context_processors": []},
    },
]

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ["POSTGRES_DB"],
        "USER": os.environ["POSTGRES_USER"],
        "PASSWORD": os.environ["POSTGRES_PASSWORD"],
        "HOST": os.environ["POSTGRES_HOST"],
        "PORT": os.environ.get("POSTGRES_PORT", "5432"),
    },
    "wordpress": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": os.environ["WORDPRESS_DB_NAME"],
        "USER": os.environ["WORDPRESS_DB_USER"],
        "PASSWORD": os.environ["WORDPRESS_DB_PASSWORD"],
        "HOST": os.environ["WORDPRESS_DB_HOST"],
        "PORT": os.environ.get("WORDPRESS_DB_PORT", "3306"),
    },
}

LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True
STATIC_URL = "static/"
STATICFILES_DIRS = [BASE_DIR / "static"]
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


def _mounted_public_keys():
    directory = Path("/shared")
    if not directory.is_dir():
        return []
    return [
        path.read_bytes()
        for path in sorted(directory.glob("*.pem"))
        if path.stat().st_size
    ]


SHARED_AUTH_PUBLIC_KEYS = _mounted_public_keys()

REST_FRAMEWORK = {
    "EXCEPTION_HANDLER": "config.exceptions.api_exception_handler",
    "DEFAULT_AUTHENTICATION_CLASSES": [],
    "UNAUTHENTICATED_USER": None,
}
