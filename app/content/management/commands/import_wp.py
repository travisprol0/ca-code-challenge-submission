import logging
import os
import re
from datetime import timezone

import pymysql
from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from shared_auth.ids import public_id_for_wp_user

from content.models import Brand, Industry, Page, Review, Reviewer, recalculate_brand_stats

logger = logging.getLogger(__name__)

POST_TYPES = ("brand", "review", "page")
SHORT_DESCRIPTION_WORDS = 22
MAPPED_BRAND_META = {
    "website_url",
    "founded_year",
    "headquarters",
    "_yoast_wpseo_title",
    "_yoast_wpseo_metadesc",
}
MAPPED_REVIEW_META = {"rating", "reviewer_location", "brand"}
DROPPED_META = {"average_rating"}
REVIEW_FIELDS = (
    "slug",
    "title",
    "body",
    "rating",
    "reviewer_location",
    "published_at",
    "brand",
    "is_published",
)


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument("--batch-size", dest="batch_size", type=int, default=100)

    def handle(self, *args, **options):
        prefix = _prefix()
        connection = _connect()
        try:
            with transaction.atomic():
                reviewers = _import_reviewers(connection, prefix)
                batch_size = options["batch_size"]
                for cursor, posts, meta in _batches(connection, prefix, batch_size):
                    for post in posts:
                        if post["post_type"] == "page":
                            _import_about(post)
                    _import_brands(
                        cursor,
                        prefix,
                        [post for post in posts if post["post_type"] == "brand"],
                        meta,
                    )
                for _cursor, posts, meta in _batches(connection, prefix, batch_size):
                    _import_reviews(
                        [post for post in posts if post["post_type"] == "review"],
                        meta,
                        reviewers,
                    )
                recalculate_brand_stats(list(Brand.all_objects.values_list("pk", flat=True)))
        finally:
            connection.close()


def _prefix():
    prefix = os.environ.get("WORDPRESS_TABLE_PREFIX", "wp_")
    if not prefix.replace("_", "").isalnum():
        raise CommandError("WORDPRESS_TABLE_PREFIX is not a table prefix")
    return prefix


def _connect():
    return pymysql.connect(
        host=os.environ["WORDPRESS_DB_HOST"],
        port=int(os.environ.get("WORDPRESS_DB_PORT", "3306")),
        user=os.environ["WORDPRESS_DB_USER"],
        password=os.environ["WORDPRESS_DB_PASSWORD"],
        database=os.environ["WORDPRESS_DB_NAME"],
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
    )


def _import_reviewers(connection, prefix):
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            SELECT users.ID, users.display_name
            FROM {prefix}users AS users
            JOIN {prefix}posts AS posts
              ON posts.post_author = users.ID
            WHERE posts.post_status = 'publish'
              AND posts.post_type = 'review'
              AND posts.post_author <> 0
              AND users.user_login <> 'admin'
            GROUP BY users.ID, users.display_name
            """
        )
        rows = cursor.fetchall()
    reviewers = {}
    for row in rows:
        reviewer, _created = Reviewer.objects.get_or_create(
            wp_id=row["ID"],
            defaults={
                "public_id": public_id_for_wp_user(row["ID"]),
                "display_name": row["display_name"],
            },
        )
        reviewers[row["ID"]] = reviewer
    return reviewers


def _batches(connection, prefix, batch_size):
    last_id = 0
    with connection.cursor() as cursor:
        while True:
            posts = _post_batch(cursor, prefix, last_id, batch_size)
            if not posts:
                break
            last_id = posts[-1]["ID"]
            meta = _postmeta_batch(cursor, prefix, [post["ID"] for post in posts])
            yield cursor, posts, meta


def _post_batch(cursor, prefix, last_id, batch_size):
    placeholders = ", ".join(["%s"] * len(POST_TYPES))
    cursor.execute(
        f"""
        SELECT ID, post_author, post_date, post_content, post_title, post_name, post_type
        FROM {prefix}posts
        WHERE ID > %s
          AND post_status = 'publish'
          AND post_type IN ({placeholders})
        ORDER BY ID
        LIMIT %s
        """,
        [last_id, *POST_TYPES, batch_size],
    )
    return list(cursor.fetchall())


def _postmeta_batch(cursor, prefix, post_ids):
    placeholders = ", ".join(["%s"] * len(post_ids))
    cursor.execute(
        f"""
        SELECT post_id, meta_key, meta_value
        FROM {prefix}postmeta
        WHERE post_id IN ({placeholders})
        """,
        post_ids,
    )
    grouped = {}
    for row in cursor.fetchall():
        grouped.setdefault(row["post_id"], {})[row["meta_key"]] = row["meta_value"]
    return grouped


def _import_about(post):
    if post["post_name"] != "about":
        return
    fields = {
        "slug": post["post_name"],
        "title": post["post_title"],
        "body": post["post_content"],
        "is_published": True,
    }
    page, created = Page.objects.get_or_create(wp_id=post["ID"], defaults=fields)
    if created:
        return
    for name, value in fields.items():
        setattr(page, name, value)
    page.save(update_fields=list(fields))


def _import_brands(cursor, prefix, posts, meta):
    if not posts:
        return
    linked = _industries_by_post(cursor, prefix, [post["ID"] for post in posts])
    brands = [
        Brand(
            wp_id=post["ID"],
            short_description=_short_description(post["post_content"]),
            **_brand_fields(post, meta.get(post["ID"], {})),
        )
        for post in posts
    ]
    Brand.all_objects.bulk_create(
        brands,
        update_conflicts=True,
        unique_fields=["wp_id"],
        update_fields=[
            "slug",
            "title",
            "body",
            "website_url",
            "founded_year",
            "headquarters",
            "seo_title",
            "seo_description",
            "is_published",
        ],
    )
    saved = {
        brand.wp_id: brand
        for brand in Brand.all_objects.filter(wp_id__in=[post["ID"] for post in posts])
    }
    for post in posts:
        _log_unmapped_meta(post["ID"], meta.get(post["ID"], {}), MAPPED_BRAND_META)
        saved[post["ID"]].industries.set(linked.get(post["ID"], []))


def _log_unmapped_meta(post_id, meta, mapped):
    for key in meta:
        if key.startswith("_") or key in mapped or key in DROPPED_META:
            continue
        logger.warning("unmapped postmeta %s for post %s", key, post_id)


def _brand_fields(post, meta):
    founded_year = meta.get("founded_year")
    return {
        "slug": post["post_name"],
        "title": post["post_title"],
        "body": post["post_content"],
        "website_url": meta.get("website_url") or "",
        "founded_year": int(founded_year) if founded_year else None,
        "headquarters": meta.get("headquarters") or "",
        "seo_title": meta.get("_yoast_wpseo_title") or "",
        "seo_description": meta.get("_yoast_wpseo_metadesc") or "",
        "is_published": True,
    }


def _industries_by_post(cursor, prefix, post_ids):
    placeholders = ", ".join(["%s"] * len(post_ids))
    cursor.execute(
        f"""
        SELECT relationships.object_id AS post_id, terms.term_id, terms.slug, terms.name
        FROM {prefix}term_relationships AS relationships
        JOIN {prefix}term_taxonomy AS taxonomy
          ON taxonomy.term_taxonomy_id = relationships.term_taxonomy_id
        JOIN {prefix}terms AS terms
          ON terms.term_id = taxonomy.term_id
        WHERE taxonomy.taxonomy = 'industry'
          AND relationships.object_id IN ({placeholders})
        """,
        post_ids,
    )
    grouped = {}
    for row in cursor.fetchall():
        industry, created = Industry.objects.get_or_create(
            wp_id=row["term_id"],
            defaults={"slug": row["slug"], "name": row["name"]},
        )
        if not created and industry.slug != row["slug"]:
            industry.slug = row["slug"]
            industry.save(update_fields=["slug"])
        if not created and industry.name != row["name"]:
            industry.name = row["name"]
            industry.save(update_fields=["name"])
        grouped.setdefault(row["post_id"], [])
        if industry not in grouped[row["post_id"]]:
            grouped[row["post_id"]].append(industry)
    return grouped


def _import_reviews(posts, meta, reviewers):
    if not posts:
        return
    existing = {
        review.wp_id: review
        for review in Review.all_objects.filter(wp_id__in=[post["ID"] for post in posts])
    }
    to_create = []
    to_update = []
    for post in posts:
        post_meta = meta.get(post["ID"], {})
        _log_unmapped_meta(post["ID"], post_meta, MAPPED_REVIEW_META)
        values = _review_fields(post, post_meta, reviewers)
        current = existing.get(post["ID"])
        if current is None:
            to_create.append(Review(wp_id=post["ID"], **values))
            continue
        for name, value in values.items():
            setattr(current, name, value)
        to_update.append(current)
    if to_create:
        Review.all_objects.bulk_create(to_create)
    if to_update:
        Review.all_objects.bulk_update(to_update, list(REVIEW_FIELDS))


def _review_fields(post, meta, reviewers):
    reviewer = reviewers.get(post["post_author"])
    if reviewer is None:
        raise CommandError(f"review {post['ID']} has no imported reviewer")
    try:
        brand = Brand.all_objects.get(wp_id=int(meta["brand"]))
    except Brand.DoesNotExist:
        raise CommandError(f"review {post['ID']} brand is absent from the extract")
    return {
        "slug": post["post_name"],
        "title": post["post_title"],
        "body": post["post_content"],
        "rating": int(meta["rating"]),
        "reviewer": reviewer,
        "reviewer_location": meta.get("reviewer_location") or "",
        "published_at": _as_utc(post["post_date"]),
        "brand": brand,
        "is_published": True,
    }


def _as_utc(post_date):
    if post_date.tzinfo is None:
        return post_date.replace(tzinfo=timezone.utc)
    return post_date


def _short_description(html):
    text = re.sub(r"(?is)<(script|style)\b[^>]*>.*?</\1>", "", html or "")
    text = re.sub(r"<[^>]+>", "", text).strip()
    words = [word for word in re.split(r"[\n\r\t ]+", text) if word]
    if len(words) <= SHORT_DESCRIPTION_WORDS:
        return " ".join(words)
    return " ".join(words[:SHORT_DESCRIPTION_WORDS]) + "…"
