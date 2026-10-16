from jwt.exceptions import PyJWTError
from rest_framework.exceptions import AuthenticationFailed, NotAuthenticated
from rest_framework.views import exception_handler


def api_exception_handler(exc, context):
    if isinstance(exc, PyJWTError):
        exc = AuthenticationFailed()
    response = exception_handler(exc, context)
    if response is not None and isinstance(exc, (NotAuthenticated, AuthenticationFailed)):
        response.status_code = 401
    return response
