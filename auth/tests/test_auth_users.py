import pytest
from django.core.management import call_command

pytestmark = pytest.mark.django_db

REVIEWERS = [
    "sarah_k",
    "mike_t",
    "jenny_w",
    "david_l",
    "anna_r",
    "roberto_g",
    "maya_p",
    "kenji_o",
]


def import_users():
    call_command("import_wp_users")


def test_admin_access_token_includes_brands_edit_and_reader_does_not():
    import jwt
    from rest_framework.test import APIClient
    from shared_auth.claims import BRANDS_EDIT

    import_users()
    client = APIClient()

    admin = client.post(
        "/api/token/",
        {"username": "admin", "password": "admin"},
        format="json",
    )
    assert admin.status_code == 200
    admin_permissions = jwt.decode(
        admin.json()["access"],
        options={"verify_signature": False},
    )["permissions"]
    assert BRANDS_EDIT in admin_permissions

    reader = client.post(
        "/api/token/",
        {"username": "sarah_k", "password": "changeme"},
        format="json",
    )
    assert reader.status_code == 200
    reader_permissions = jwt.decode(
        reader.json()["access"],
        options={"verify_signature": False},
    )["permissions"]
    assert BRANDS_EDIT not in reader_permissions


def test_imported_passwords_accept_seed_reject_raw_bcrypt_and_rehash_on_login():
    import bcrypt
    from django.contrib.auth import get_user_model
    from rest_framework.test import APIClient

    import_users()
    User = get_user_model()
    sarah = User.objects.get(username="sarah_k")
    assert sarah.check_password("changeme")
    assert not sarah.check_password("wrong-password")
    bcrypt_hash = sarah.password[sarah.password.index("$2y$") :].encode()
    assert bcrypt.checkpw(b"changeme", bcrypt_hash) is False

    admin = User.objects.get(username="admin")
    assert admin.check_password("admin")

    client = APIClient()
    assert (
        client.post(
            "/api/token/",
            {"username": "sarah_k", "password": "changeme"},
            format="json",
        ).status_code
        == 200
    )
    assert (
        client.post(
            "/api/token/",
            {"username": "admin", "password": "admin"},
            format="json",
        ).status_code
        == 200
    )
    sarah.refresh_from_db()
    admin.refresh_from_db()
    assert not sarah.password.startswith("wp$")
    assert not admin.password.startswith("wp$")

    for username in REVIEWERS:
        if username == "sarah_k":
            continue
        assert User.objects.get(username=username).check_password("changeme")


def test_import_twice_keeps_nine_users_and_assigns_roles():
    from django.contrib.auth import get_user_model
    from shared_auth.ids import public_id_for_wp_user

    import_users()
    import_users()
    User = get_user_model()
    assert User.objects.count() == 9
    sarah = User.objects.get(username="sarah_k")
    assert sarah.public_id == public_id_for_wp_user(2)
    admin = User.objects.get(username="admin")
    assert admin.groups.filter(name="editor").exists()
    reviewers = User.objects.filter(username__in=REVIEWERS)
    assert reviewers.count() == 8
    for reviewer in reviewers:
        assert reviewer.groups.filter(name="reader").exists()


def test_second_import_keeps_a_rehashed_password():
    from django.contrib.auth import get_user_model
    from rest_framework.test import APIClient

    import_users()
    client = APIClient()
    assert (
        client.post(
            "/api/token/",
            {"username": "sarah_k", "password": "changeme"},
            format="json",
        ).status_code
        == 200
    )
    import_users()
    User = get_user_model()
    sarah = User.objects.get(username="sarah_k")
    assert not sarah.password.startswith("wp$")
    assert sarah.check_password("changeme")


def test_second_import_still_accepts_a_user_who_has_not_logged_in():
    from django.contrib.auth import get_user_model

    import_users()
    import_users()
    User = get_user_model()
    mike = User.objects.get(username="mike_t")
    assert mike.password.startswith("wp$")
    assert mike.check_password("changeme")
