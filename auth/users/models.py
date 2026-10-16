import uuid

from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import PermissionsMixin
from django.db import models


class UserManager(BaseUserManager):
    use_in_migrations = True

    def create_user(self, username, email="", password=None, **extra):
        if not username:
            raise ValueError("username is required")
        user = self.model(username=username, email=email, **extra)
        if password:
            user.set_password(password)
        else:
            user.set_unusable_password()
        user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(max_length=150, unique=True)
    email = models.EmailField(blank=True)
    wp_user_id = models.PositiveIntegerField(unique=True, null=True, blank=True)
    public_id = models.UUIDField(unique=True, default=uuid.uuid4)
    is_active = models.BooleanField(default=True)

    USERNAME_FIELD = "username"
    REQUIRED_FIELDS = []

    objects = UserManager()

    def check_password(self, raw_password):
        return check_password(raw_password, self.password)
