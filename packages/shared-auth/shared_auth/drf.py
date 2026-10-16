from django.conf import settings
from rest_framework.authentication import BaseAuthentication
from rest_framework.permissions import BasePermission

from shared_auth.verify import verify


class Principal:
    def __init__(self, permissions=()):
        self.is_authenticated = True
        self.permissions = frozenset(permissions)


class Authentication(BaseAuthentication):
    def authenticate(self, request):
        header = request.META.get("HTTP_AUTHORIZATION", "")
        scheme, _, token = header.partition(" ")
        if scheme.lower() != "bearer" or not token:
            return None
        claims = verify(token, settings.SHARED_AUTH_PUBLIC_KEYS)
        permissions = claims.get("permissions")
        if not isinstance(permissions, list):
            permissions = ()
        return Principal(permissions=permissions), token


class HasPermission(BasePermission):
    def __init__(self, name):
        self.name = name

    def __call__(self):
        return self

    def has_permission(self, request, view):
        return self.name in getattr(request.user, "permissions", ())
