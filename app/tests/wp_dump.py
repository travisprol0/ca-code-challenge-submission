import os
import subprocess
from pathlib import Path

import pymysql
from django.core.management.base import CommandError


def load_wordpress_dump(database):
    database = _identifier(database)
    if database != "wp":
        _create_database(database)
    current = _current_database(database)
    if current == "wp":
        raise CommandError("DATABASE() is wp")
    _load_with_client(database)


def drop_wordpress_database(database):
    database = _identifier(database)
    if database == "wp":
        raise CommandError("DATABASE() is wp")
    connection = _root_connect(None)
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT DATABASE()")
            if _database_name(cursor.fetchone()) == "wp":
                raise CommandError("DATABASE() is wp")
            cursor.execute(f"DROP DATABASE IF EXISTS `{database}`")
    finally:
        connection.close()


def _create_database(database):
    connection = _root_connect(None)
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT DATABASE()")
            if _database_name(cursor.fetchone()) == "wp":
                raise CommandError("DATABASE() is wp")
            cursor.execute(
                f"CREATE DATABASE IF NOT EXISTS `{database}` "
                "CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
            )
            user = _identifier(os.environ["WORDPRESS_DB_USER"])
            cursor.execute(f"GRANT ALL ON `{database}`.* TO '{user}'@'%'")
    finally:
        connection.close()


def _current_database(database):
    connection = _root_connect(database)
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT DATABASE()")
            return _database_name(cursor.fetchone())
    finally:
        connection.close()


def _load_with_client(database):
    completed = subprocess.run(
        [
            "mariadb",
            "--host",
            os.environ["WORDPRESS_DB_HOST"],
            "--port",
            os.environ.get("WORDPRESS_DB_PORT", "3306"),
            "--user",
            "root",
            f"--password={os.environ.get('MYSQL_ROOT_PASSWORD', 'root')}",
            "--skip-ssl",
            "--database",
            database,
        ],
        input=_dump_sql(_dump_path()),
        capture_output=True,
        check=False,
    )
    if completed.returncode != 0:
        detail = completed.stderr.decode() or completed.stdout.decode()
        raise CommandError(detail.strip())


def _dump_path():
    mounted = Path("/srv/db/dump.sql")
    if mounted.is_file():
        return mounted
    repo = Path(__file__).resolve().parents[2] / "db" / "dump.sql"
    if repo.is_file():
        return repo
    raise CommandError("db/dump.sql is not available")


def _dump_sql(path):
    data = path.read_bytes()
    first, _newline, rest = data.partition(b"\n")
    if b"enable the sandbox mode" in first:
        return rest
    return data


def _root_connect(database):
    return pymysql.connect(
        host=os.environ["WORDPRESS_DB_HOST"],
        port=int(os.environ.get("WORDPRESS_DB_PORT", "3306")),
        user="root",
        password=os.environ.get("MYSQL_ROOT_PASSWORD", "root"),
        database=database,
        charset="utf8mb4",
        autocommit=True,
    )


def _database_name(row):
    if not row:
        return None
    if isinstance(row, dict):
        return next(iter(row.values()))
    return row[0]


def _identifier(value):
    if not value or not value.replace("_", "").isalnum():
        raise CommandError("database name is not safe")
    return value
