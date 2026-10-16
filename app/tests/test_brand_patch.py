import html
import time
from contextlib import contextmanager

import jwt
import pytest
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from django.core.management import call_command
from django.test import override_settings
from rest_framework.test import APIClient

pytestmark = pytest.mark.django_db(databases=["default"])

ISS = "ca-code-challenge-auth"
AUD = "ca-code-challenge"
BRANDS_EDIT = "brands.edit"


@pytest.fixture(autouse=True)
def wordpress_database(monkeypatch):
    monkeypatch.setenv("WORDPRESS_DB_NAME", "wp_test")


@pytest.fixture(scope="session", autouse=True)
def wordpress_dump():
    from tests.wp_dump import drop_wordpress_database, load_wordpress_dump

    load_wordpress_dump("wp_test")
    try:
        yield
    finally:
        drop_wordpress_database("wp_test")


def test_editor_patch_is_200_and_reader_is_403():
    private_pem, public_pem = rsa_pem()
    brand = make_brand(short_description="original")

    with mounted_keys(public_pem):
        editor = patch_brand(
            brand.slug,
            private_pem,
            "edited by an editor",
            permissions=[BRANDS_EDIT],
        )
        assert editor.status_code == 200

        reader = patch_brand(
            brand.slug,
            private_pem,
            "edited by a reader",
            permissions=[],
        )
        assert reader.status_code == 403

        role_name = patch_brand(
            brand.slug,
            private_pem,
            "edited by a role name",
            permissions=["editor"],
        )
        assert role_name.status_code == 403

    brand.refresh_from_db()
    assert brand.short_description == "edited by an editor"
    assert brand.title == "Acme"


def test_missing_expired_wrong_issuer_and_wrong_audience_are_401():
    private_pem, public_pem = rsa_pem()
    brand = make_brand(short_description="original")
    client = APIClient()
    url = f"/api/brands/{brand.slug}/"
    body = {"short_description": "should not save"}

    with mounted_keys(public_pem):
        missing = client.patch(url, body, format="json")
        expired = client.patch(
            url,
            body,
            format="json",
            HTTP_AUTHORIZATION=bearer(private_pem, claims(exp=int(time.time()) - 60)),
        )
        wrong_issuer = client.patch(
            url,
            body,
            format="json",
            HTTP_AUTHORIZATION=bearer(private_pem, claims(iss="other-issuer")),
        )
        wrong_audience = client.patch(
            url,
            body,
            format="json",
            HTTP_AUTHORIZATION=bearer(private_pem, claims(aud="other-audience")),
        )
        invalid = client.patch(url, body, format="json", HTTP_AUTHORIZATION="Bearer not-a-token")

    assert missing.status_code == 401
    assert expired.status_code == 401
    assert wrong_issuer.status_code == 401
    assert wrong_audience.status_code == 401
    assert invalid.status_code == 401
    brand.refresh_from_db()
    assert brand.short_description == "original"


def test_extra_field_is_400_and_empty_survives_import_wp():
    call_command("import_wp")
    from content.models import Brand

    private_pem, public_pem = rsa_pem()
    brand = Brand.objects.get(slug="acme-insurance")
    original = brand.short_description
    assert original != ""

    with mounted_keys(public_pem):
        extra = patch_brand(
            brand.slug,
            private_pem,
            "should not save",
            extra={"title": "Changed"},
        )
        assert extra.status_code == 400
        brand.refresh_from_db()
        assert brand.short_description == original
        assert brand.title == "Acme Insurance Co."

        cleared = patch_brand(brand.slug, private_pem, "")
        assert cleared.status_code == 200

    call_command("import_wp")
    brand.refresh_from_db()
    assert brand.short_description == ""


def test_get_shows_the_new_text_and_the_page_escapes_it():
    private_pem, public_pem = rsa_pem()
    brand = make_brand(slug="acme-insurance", title="Acme Insurance Co.")
    raw = '<script>alert("x")</script>'

    with mounted_keys(public_pem):
        saved = patch_brand(brand.slug, private_pem, raw)
        assert saved.status_code == 200

    listing = APIClient().get("/api/brands/")
    assert listing.status_code == 200
    rows = {row["slug"]: row for row in listing.json()["results"]}
    assert rows[brand.slug]["short_description"] == raw

    page = APIClient().get(f"/brand/{brand.slug}/")
    assert page.status_code == 200
    body = page.content.decode()
    assert html.escape(raw, quote=True) in body
    assert raw not in body


def test_either_mounted_key_works_and_an_unknown_key_is_rejected():
    first_private, first_public = rsa_pem()
    second_private, second_public = rsa_pem()
    unknown_private, _unknown_public = rsa_pem()
    brand = make_brand(short_description="original")

    with mounted_keys(first_public, second_public):
        first = patch_brand(brand.slug, first_private, "signed by the first key")
        second = patch_brand(brand.slug, second_private, "signed by the second key")
        unknown = patch_brand(brand.slug, unknown_private, "signed by an unknown key")

    assert first.status_code == 200
    assert second.status_code == 200
    assert unknown.status_code == 401
    brand.refresh_from_db()
    assert brand.short_description == "signed by the second key"


def test_patch_succeeds_while_the_auth_service_is_stopped(monkeypatch):
    def refuse(*args, **kwargs):
        raise AssertionError("auth service was contacted")

    monkeypatch.setattr("urllib.request.urlopen", refuse)
    monkeypatch.setattr("http.client.HTTPConnection.request", refuse)
    monkeypatch.setattr("http.client.HTTPSConnection.request", refuse)

    private_pem, public_pem = rsa_pem()
    brand = make_brand(short_description="original")

    with mounted_keys(public_pem):
        response = patch_brand(brand.slug, private_pem, "saved without auth")
        listing = APIClient().get("/api/brands/")

    assert response.status_code == 200
    assert listing.status_code == 200
    brand.refresh_from_db()
    assert brand.short_description == "saved without auth"


def patch_brand(slug, private_pem, short_description, permissions=None, extra=None):
    if permissions is None:
        permissions = [BRANDS_EDIT]
    body = {"short_description": short_description}
    if extra:
        body.update(extra)
    return APIClient().patch(
        f"/api/brands/{slug}/",
        body,
        format="json",
        HTTP_AUTHORIZATION=bearer(private_pem, claims(permissions=permissions)),
    )


def bearer(private_pem, payload):
    return "Bearer " + jwt.encode(payload, private_pem, algorithm="RS256")


def claims(**overrides):
    payload = {
        "iss": ISS,
        "aud": AUD,
        "sub": "editor-1",
        "exp": int(time.time()) + 60,
        "token_type": "access",
        "permissions": [BRANDS_EDIT],
    }
    payload.update(overrides)
    return payload


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


@contextmanager
def mounted_keys(*public_pems):
    with override_settings(SHARED_AUTH_PUBLIC_KEYS=list(public_pems)):
        yield


def make_brand(**overrides):
    from content.models import Brand

    fields = {"wp_id": 1, "slug": "acme", "title": "Acme", "is_published": True}
    fields.update(overrides)
    return Brand.objects.create(**fields)
