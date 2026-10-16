import jwt
from jwt.exceptions import InvalidTokenError, PyJWTError

from shared_auth.claims import aud, iss


def verify(token, public_keys):
    error = InvalidTokenError("no configured key accepted the token")
    for key in public_keys:
        try:
            decoded = jwt.decode(
                token,
                key,
                algorithms=["RS256"],
                audience=aud,
                issuer=iss,
                options={"require": ["exp", "iss", "aud", "sub"]},
            )
        except PyJWTError as exc:
            error = exc
            continue
        if decoded.get("token_type") != "access":
            raise InvalidTokenError("token_type")
        return decoded
    if not isinstance(error, InvalidTokenError):
        raise InvalidTokenError(str(error)) from error
    raise error
