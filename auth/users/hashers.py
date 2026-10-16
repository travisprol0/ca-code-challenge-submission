import base64
import hashlib
import hmac

import bcrypt
from django.contrib.auth.hashers import BasePasswordHasher


class WordPressPasswordHasher(BasePasswordHasher):
    algorithm = "wp"

    def encode(self, password, salt):
        raise NotImplementedError("imported WordPress hashes are stored as wp$$wp$2y$...")

    def verify(self, password, encoded):
        marker = "$2y$"
        if marker not in encoded:
            return False
        hashed = encoded[encoded.index(marker) :].encode("ascii")
        prehashed = base64.b64encode(
            hmac.new(
                b"wp-sha384",
                password.strip().encode("utf-8"),
                hashlib.sha384,
            ).digest()
        )
        try:
            return bcrypt.checkpw(prehashed, hashed)
        except ValueError:
            return False

    def must_update(self, encoded):
        return True

    def harden_runtime(self, password, encoded):
        self.verify(password, encoded)
