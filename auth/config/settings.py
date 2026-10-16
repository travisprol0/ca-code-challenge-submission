import os
from datetime import timedelta
from pathlib import Path

from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = "dev-scaffold-not-for-production"
DEBUG = True
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.staticfiles",
    "rest_framework",
    "users",
]

AUTH_USER_MODEL = "users.User"

PASSWORD_HASHERS = [
    "django.contrib.auth.hashers.PBKDF2PasswordHasher",
    "users.hashers.WordPressPasswordHasher",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
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
}

LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True
STATIC_URL = "static/"
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

WORDPRESS_DB = {
    "host": os.environ.get("WORDPRESS_DB_HOST", "db"),
    "port": int(os.environ.get("WORDPRESS_DB_PORT", "3306")),
    "database": os.environ.get("WORDPRESS_DB_NAME", "wp"),
    "user": os.environ.get("WORDPRESS_DB_USER", "wp"),
    "password": os.environ.get("WORDPRESS_DB_PASSWORD", "wp"),
    "prefix": os.environ.get("WORDPRESS_TABLE_PREFIX", "wp_"),
}


def _pem_keys():
    private_path = Path("/keys/private.pem")
    public_path = Path("/shared/public.pem")
    if private_path.is_file() and private_path.stat().st_size:
        private_pem = private_path.read_text()
        if public_path.is_file() and public_path.stat().st_size:
            return private_pem, public_path.read_text()
        private_key = serialization.load_pem_private_key(private_pem.encode(), password=None)
        public_pem = private_key.public_key().public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo,
        )
        return private_pem, public_pem.decode()
    private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption(),
    )
    public_pem = private_key.public_key().public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo,
    )
    return private_pem.decode(), public_pem.decode()


_SIGNING_KEY, _VERIFYING_KEY = _pem_keys()

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=5),
    "ALGORITHM": "RS256",
    "SIGNING_KEY": _SIGNING_KEY,
    "VERIFYING_KEY": _VERIFYING_KEY,
    "USER_ID_FIELD": "public_id",
    "USER_ID_CLAIM": "sub",
}
