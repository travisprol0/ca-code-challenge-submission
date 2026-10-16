import pymysql
from django.conf import settings
from django.contrib.auth.models import Group
from django.core.management.base import BaseCommand, CommandError
from shared_auth.ids import public_id_for_wp_user

from users.models import User


def php_unserialize(raw):
    value, index = _parse(raw, 0)
    if index != len(raw):
        raise ValueError("trailing data in php value")
    return value


def _parse(raw, index):
    kind = raw[index]
    if kind == "a":
        header_end = raw.index(":{", index)
        count = int(raw[index + 2 : header_end])
        index = header_end + 2
        items = {}
        for _ in range(count):
            key, index = _parse(raw, index)
            item, index = _parse(raw, index)
            items[key] = item
        if raw[index] != "}":
            raise ValueError("array did not close")
        return items, index + 1
    if kind == "s":
        colon = raw.index(":", index + 2)
        length = int(raw[index + 2 : colon])
        start = colon + 2
        value = raw[start : start + length]
        return value, start + length + 2
    if kind == "b":
        return raw[index + 2] == "1", index + 4
    if kind == "i":
        end = raw.index(";", index)
        return int(raw[index + 2 : end]), end + 1
    raise ValueError(f"unsupported php type {kind}")


class Command(BaseCommand):
    def handle(self, *args, **options):
        config = settings.WORDPRESS_DB
        prefix = config["prefix"]
        if not prefix.replace("_", "").isalnum():
            raise CommandError("WORDPRESS_TABLE_PREFIX is not a table prefix")
        editor, _ = Group.objects.get_or_create(name="editor")
        reader, _ = Group.objects.get_or_create(name="reader")
        connection = pymysql.connect(
            host=config["host"],
            port=config["port"],
            user=config["user"],
            password=config["password"],
            database=config["database"],
            cursorclass=pymysql.cursors.DictCursor,
        )
        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"""
                    SELECT users.ID, users.user_login, users.user_pass, users.user_email,
                           caps.meta_value AS capabilities
                    FROM {prefix}users AS users
                    LEFT JOIN {prefix}usermeta AS caps
                      ON caps.user_id = users.ID AND caps.meta_key = %s
                    """,
                    [f"{prefix}capabilities"],
                )
                rows = cursor.fetchall()
        finally:
            connection.close()
        for row in rows:
            wp_user_id = row["ID"]
            user, _created = User.objects.update_or_create(
                wp_user_id=wp_user_id,
                defaults={
                    "username": row["user_login"],
                    "email": row["user_email"] or "",
                    "public_id": public_id_for_wp_user(wp_user_id),
                },
            )
            if not user.password or user.password.startswith("wp$"):
                user.password = f"wp${row['user_pass']}"
                user.save(update_fields=["password"])
            groups = []
            capabilities = php_unserialize(row["capabilities"] or "a:0:{}")
            if capabilities.get("administrator"):
                groups.append(editor)
            if capabilities.get("subscriber"):
                groups.append(reader)
            user.groups.set(groups)
