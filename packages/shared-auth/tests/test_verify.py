import base64
import hashlib
import hmac
import json
import time

import jwt
import pytest
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

from shared_auth.verify import verify

ISS = "ca-code-challenge-auth"
AUD = "ca-code-challenge"


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


def claims(**overrides):
    payload = {
        "iss": ISS,
        "aud": AUD,
        "sub": "2",
        "exp": int(time.time()) + 60,
        "token_type": "access",
    }
    payload.update(overrides)
    return payload


def signed(private_pem, payload):
    return jwt.encode(payload, private_pem, algorithm="RS256")


def test_token_signed_by_configured_key_is_accepted():
    private_pem, public_pem = rsa_pem()
    token = signed(private_pem, claims())

    decoded = verify(token, [public_pem])

    assert decoded["sub"] == "2"
    assert decoded["iss"] == ISS
    assert decoded["aud"] == AUD


def test_token_signed_by_second_configured_key_is_accepted():
    _first_private, first_public = rsa_pem()
    second_private, second_public = rsa_pem()
    token = signed(second_private, claims())

    decoded = verify(token, [first_public, second_public])

    assert decoded["sub"] == "2"


def test_token_with_kid_is_accepted_without_key_lookup():
    private_pem, public_pem = rsa_pem()
    token = jwt.encode(
        claims(),
        private_pem,
        algorithm="RS256",
        headers={"kid": "not-configured"},
    )

    decoded = verify(token, [public_pem])

    assert decoded["sub"] == "2"


def test_unknown_key_is_rejected():
    private_pem, _public_pem = rsa_pem()
    _other_private, other_public = rsa_pem()
    token = signed(private_pem, claims())

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [other_public])


def test_wrong_issuer_is_rejected():
    private_pem, public_pem = rsa_pem()
    token = signed(private_pem, claims(iss="other-issuer"))

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_wrong_audience_is_rejected():
    private_pem, public_pem = rsa_pem()
    token = signed(private_pem, claims(aud="other-audience"))

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_missing_exp_is_rejected():
    private_pem, public_pem = rsa_pem()
    payload = claims()
    del payload["exp"]
    token = signed(private_pem, payload)

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_missing_iss_is_rejected():
    private_pem, public_pem = rsa_pem()
    payload = claims()
    del payload["iss"]
    token = signed(private_pem, payload)

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_missing_aud_is_rejected():
    private_pem, public_pem = rsa_pem()
    payload = claims()
    del payload["aud"]
    token = signed(private_pem, payload)

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_missing_sub_is_rejected():
    private_pem, public_pem = rsa_pem()
    payload = claims()
    del payload["sub"]
    token = signed(private_pem, payload)

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_expired_exp_is_rejected():
    private_pem, public_pem = rsa_pem()
    token = signed(private_pem, claims(exp=int(time.time()) - 60))

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def _b64url(raw):
    return base64.urlsafe_b64encode(raw).rstrip(b"=")


def test_alg_none_is_rejected():
    private_pem, public_pem = rsa_pem()
    del private_pem
    header = _b64url(json.dumps({"alg": "none", "typ": "JWT"}).encode())
    body = _b64url(json.dumps(claims()).encode())
    token = header.decode() + "." + body.decode() + "."

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_hs256_signed_with_public_key_is_rejected():
    _private_pem, public_pem = rsa_pem()
    header = _b64url(json.dumps({"alg": "HS256", "typ": "JWT"}).encode())
    body = _b64url(json.dumps(claims()).encode())
    signing_input = header + b"." + body
    signature = hmac.new(public_pem, signing_input, hashlib.sha256).digest()
    token = (signing_input + b"." + _b64url(signature)).decode()

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])


def test_non_access_token_type_is_rejected():
    private_pem, public_pem = rsa_pem()
    token = signed(private_pem, claims(token_type="refresh"))

    with pytest.raises(jwt.InvalidTokenError):
        verify(token, [public_pem])
