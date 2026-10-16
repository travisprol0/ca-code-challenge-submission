import time

import jwt
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from django.conf import settings

if not settings.configured:
    settings.configure(SECRET_KEY="test", SHARED_AUTH_PUBLIC_KEYS=[])

import django

django.setup()

from rest_framework.test import APIRequestFactory

from shared_auth.drf import Authentication, HasPermission, Principal


def rsa_pem():
    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    private_pem = key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption(),
    )
    public_pem = key.public_key().public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo,
    )
    return private_pem, public_pem


def test_has_permission_allows_principal_that_has_it():
    request = APIRequestFactory().get("/")
    request.user = Principal(permissions={"brands.edit"})

    assert HasPermission("brands.edit").has_permission(request, None)


def test_has_permission_denies_principal_that_does_not():
    request = APIRequestFactory().get("/")
    request.user = Principal(permissions=set())

    assert not HasPermission("brands.edit").has_permission(request, None)


def test_authentication_returns_authenticated_principal():
    private_pem, public_pem = rsa_pem()
    token = jwt.encode(
        {
            "iss": "ca-code-challenge-auth",
            "aud": "ca-code-challenge",
            "sub": "2",
            "exp": int(time.time()) + 60,
            "token_type": "access",
        },
        private_pem,
        algorithm="RS256",
    )
    settings.SHARED_AUTH_PUBLIC_KEYS = [public_pem]
    request = APIRequestFactory().get("/", HTTP_AUTHORIZATION=f"Bearer {token}")

    principal, _auth = Authentication().authenticate(request)

    assert principal.is_authenticated


def test_authenticate_copies_permission_list_and_denies_a_string():
    private_pem, public_pem = rsa_pem()
    settings.SHARED_AUTH_PUBLIC_KEYS = [public_pem]
    claims = {
        "iss": "ca-code-challenge-auth",
        "aud": "ca-code-challenge",
        "sub": "2",
        "exp": int(time.time()) + 60,
        "token_type": "access",
    }

    allowed_token = jwt.encode(
        {**claims, "permissions": ["brands.edit"]},
        private_pem,
        algorithm="RS256",
    )
    allowed = APIRequestFactory().get(
        "/", HTTP_AUTHORIZATION=f"Bearer {allowed_token}"
    )
    principal, _auth = Authentication().authenticate(allowed)
    allowed.user = principal

    assert HasPermission("brands.edit").has_permission(allowed, None)

    denied_token = jwt.encode(
        {**claims, "permissions": "brands.edit"},
        private_pem,
        algorithm="RS256",
    )
    denied = APIRequestFactory().get("/", HTTP_AUTHORIZATION=f"Bearer {denied_token}")
    principal, _auth = Authentication().authenticate(denied)
    denied.user = principal

    assert principal.permissions == frozenset()
    assert not HasPermission("brands.edit").has_permission(denied, None)
