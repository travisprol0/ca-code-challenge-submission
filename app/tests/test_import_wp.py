import os
from contextlib import contextmanager
from decimal import Decimal

import pymysql
import pytest
from django.core.management import call_command
from django.core.management.base import CommandError

pytestmark = pytest.mark.django_db(databases=["default"])

ACME_SHORT_DESCRIPTION = (
    "Acme Insurance is a long-running general-lines insurer offering auto, home, "
    "and umbrella coverage across 38 US states. The company was founded in…"
)
ACME_SEO_DESCRIPTION = (
    "Read 12 independent customer reviews of Acme Insurance, a Hartford-based "
    "insurer offering auto, home, and umbrella policies in 38 US states."
)
EXPECTED_TITLES = {
    "acme-insurance": "Acme Insurance Co.",
    "primepath-bank": "PrimePath Bank",
    "homeshield-pro": "HomeShield Pro",
    "swiftstream-internet": "SwiftStream Internet",
    "urbanretail-co": "UrbanRetail Co.",
}
EXPECTED_CACHE = {
    "acme-insurance": (Decimal("3.92"), 12, "Fine but nothing special"),
    "primepath-bank": (Decimal("3.83"), 12, "Quick HELOC approval"),
    "homeshield-pro": (Decimal("3.08"), 12, "Contractor quality is inconsistent"),
    "swiftstream-internet": (Decimal("3.50"), 12, "Equipment fee feels excessive"),
    "urbanretail-co": (Decimal("3.67"), 12, "Return policy is generous, with caveats"),
}
MISMATCH_ID = 90001


@pytest.fixture(autouse=True)
def wordpress_database(monkeypatch):
    monkeypatch.setenv("WORDPRESS_DB_NAME", "wp_test")


@pytest.fixture(scope="session", autouse=True)
def wordpress_dump():
    from tests.wp_dump import drop_wordpress_database, load_wordpress_dump

    load_wordpress_dump("wp_test")
    try:
        yield
    finally:
        drop_wordpress_database("wp_test")


def test_import_twice_keeps_counts_sarahs_name_and_skips_admin():
    from content.models import Brand, Industry, Page, Review, Reviewer

    call_command("import_wp")
    first = _counts()
    sarah = Reviewer.objects.get(display_name="Sarah K.")

    call_command("import_wp")

    assert _counts() == first
    assert first == {
        "brands": 5,
        "reviews": 60,
        "reviewers": 8,
        "industries": 5,
        "pages": 1,
    }
    sarah.refresh_from_db()
    assert sarah.display_name == "Sarah K."
    assert not Reviewer.objects.filter(wp_id=_wp_user_id("admin")).exists()
    assert {
        brand.slug: brand.title for brand in Brand.objects.order_by("slug")
    } == EXPECTED_TITLES
    assert set(Brand.objects.values_list("slug", flat=True)) == set(EXPECTED_CACHE)
    assert Review.all_objects.count() == 60
    assert not Industry.objects.filter(slug="uncategorized").exists()
    assert Page.objects.get().slug == "about"


def test_a_ninth_review_author_is_imported():
    from content.models import Reviewer

    with _ninth_review_author() as author:
        call_command("import_wp")
        reviewer = Reviewer.objects.get(wp_id=author["wp_id"])
        assert reviewer.display_name == author["display_name"]


def test_import_updates_an_unpublished_brands_headquarters():
    from content.models import Brand

    call_command("import_wp")
    brand = Brand.all_objects.get(slug="acme-insurance")
    wordpress_headquarters = brand.headquarters
    brand.is_published = False
    brand.headquarters = "Nowhere, ZZ"
    brand.save(update_fields=["is_published", "headquarters"])

    call_command("import_wp")

    brand.refresh_from_db()
    assert brand.headquarters == wordpress_headquarters
    assert brand.headquarters != "Nowhere, ZZ"
    assert brand.is_published is True
    assert Brand.all_objects.values("wp_id").count() == 5


def test_edited_short_description_survives_and_headquarters_change_is_imported():
    from content.models import Brand

    call_command("import_wp")
    brand = Brand.objects.get(slug="acme-insurance")
    brand.short_description = "Kept on purpose."
    brand.save(update_fields=["short_description"])

    with _replaced_meta("acme-insurance", "headquarters", "New Haven, CT"):
        call_command("import_wp")
        brand.refresh_from_db()
        assert brand.short_description == "Kept on purpose."
        assert brand.headquarters == "New Haven, CT"

        brand.short_description = ""
        brand.save(update_fields=["short_description"])
        call_command("import_wp")
        brand.refresh_from_db()
        assert brand.short_description == ""
        assert brand.headquarters == "New Haven, CT"


def test_acme_seed_yoast_homeshield_dash_about_updates_and_home_is_absent():
    from content.models import Brand, Page

    call_command("import_wp")
    acme = Brand.objects.get(slug="acme-insurance")
    assert acme.short_description == ACME_SHORT_DESCRIPTION
    assert acme.seo_description == ACME_SEO_DESCRIPTION
    assert "—" in Brand.objects.get(slug="homeshield-pro").body
    assert not Page.objects.filter(slug="home").exists()

    replacement = "<p>About body replaced by the import test.</p>"
    with _replaced_post_content("about", replacement):
        call_command("import_wp")
        assert Page.objects.get(slug="about").body == replacement
        assert not Page.objects.filter(slug="home").exists()


def test_industry_slug_follows_wordpress_on_a_later_import():
    from content.models import Industry

    call_command("import_wp")
    industry = Industry.objects.get(slug="insurance")

    with _replaced_term_slug(industry.wp_id, "insurance-renamed"):
        call_command("import_wp")
        industry.refresh_from_db()
        assert industry.slug == "insurance-renamed"


def test_industry_name_is_the_wordpress_term_name():
    from content.models import Industry

    call_command("import_wp")
    terms = _industry_terms()
    assert {row["slug"]: row["name"] for row in terms} == {
        "insurance": "Insurance",
        "telecom": "Telecom",
        "home-services": "Home Services",
        "finance": "Finance",
        "retail": "Retail",
    }
    assert {
        industry.wp_id: industry.name for industry in Industry.objects.all()
    } == {row["term_id"]: row["name"] for row in terms}


def test_industry_name_follows_a_wordpress_name_title_casing_the_slug_would_not_produce():
    from content.models import Industry

    call_command("import_wp")
    industry = Industry.objects.get(slug="home-services")

    with _replaced_term_name(industry.wp_id, "Home & services"):
        call_command("import_wp")
        industry.refresh_from_db()
        assert industry.slug == "home-services"
        assert industry.name == "Home & services"


def test_brand_body_of_twenty_two_words_or_fewer_is_stored_in_full():
    from content.models import Brand

    twenty_two = (
        "One two three four five six seven eight nine ten eleven twelve "
        "thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty "
        "twentyone twentytwo"
    )
    shorter = "PrimePath keeps this short description whole."
    assert len(twenty_two.split()) == 22
    assert len(shorter.split()) < 22

    with _replaced_post_content("acme-insurance", f"<p>{twenty_two}</p>"):
        with _replaced_post_content("primepath-bank", f"<p>{shorter}</p>"):
            call_command("import_wp")
            acme = Brand.objects.get(slug="acme-insurance")
            prime = Brand.objects.get(slug="primepath-bank")
            assert acme.short_description == twenty_two
            assert not acme.short_description.endswith("…")
            assert prime.short_description == shorter
            assert not prime.short_description.endswith("…")


def test_industry_replace_follows_term_taxonomy_id():
    from content.models import Brand

    call_command("import_wp")
    acme = Brand.objects.get(slug="acme-insurance")
    assert set(acme.industries.values_list("slug", flat=True)) == {"insurance"}

    with _moved_industry("acme-insurance", "finance"):
        call_command("import_wp")
        assert set(acme.industries.values_list("slug", flat=True)) == {"finance"}

    with _taxonomy_mismatch("acme-insurance", "insurance"):
        call_command("import_wp")
        assert set(acme.industries.values_list("slug", flat=True)) == {"insurance"}
        assert not acme.industries.filter(slug="decoy-industry").exists()


def test_trashing_a_brand_leaves_it_published():
    from content.models import Brand

    call_command("import_wp")
    brand = Brand.objects.get(slug="acme-insurance")
    assert brand.is_published

    with _trashed_post("acme-insurance"):
        call_command("import_wp")
        brand.refresh_from_db()
        assert brand.is_published


def test_loader_aborts_when_database_is_wp_before_loading_the_dump(monkeypatch):
    from tests.wp_dump import load_wordpress_dump

    client_calls = []
    executed = []
    real_execute = pymysql.cursors.Cursor.execute

    def spy_execute(self, query, args=None):
        executed.append(query)
        if "DROP TABLE" in str(query).upper():
            raise AssertionError("dump was executed")
        return real_execute(self, query, args)

    def spy_run(*args, **kwargs):
        client_calls.append((args, kwargs))
        raise AssertionError("mariadb client was started")

    monkeypatch.setattr(pymysql.cursors.Cursor, "execute", spy_execute)
    monkeypatch.setattr("tests.wp_dump.subprocess.run", spy_run)

    with pytest.raises(CommandError):
        load_wordpress_dump("wp")

    assert client_calls == []
    assert any("DATABASE()" in str(query).upper() for query in executed)
    assert not any("DROP TABLE" in str(query).upper() for query in executed)


def test_cache_numbers_match_for_default_batch_and_batch_size_one():
    call_command("import_wp")
    assert _cache() == EXPECTED_CACHE

    _clear_imported()
    call_command("import_wp", batch_size=1)
    assert _cache() == EXPECTED_CACHE


def test_review_with_a_lower_id_than_its_brand_imports_at_batch_size_one():
    from content.models import Brand, Review

    with _review_posted_before_its_brand() as (review_id, brand_id):
        call_command("import_wp", batch_size=1)
        review = Review.all_objects.get(wp_id=review_id)
        assert review.brand == Brand.all_objects.get(wp_id=brand_id)


def test_unmapped_brand_meta_is_logged(caplog):
    with _inserted_meta("acme-insurance", "loyalty_program", "gold") as post_id:
        call_command("import_wp")
    assert "loyalty_program" in caplog.text
    assert str(post_id) in caplog.text


def test_acf_bookkeeping_keys_are_not_logged(caplog):
    call_command("import_wp")
    assert "_website_url" not in caplog.text


def test_average_rating_meta_is_not_logged(caplog):
    call_command("import_wp")
    assert "average_rating" not in caplog.text


def test_a_failure_after_brands_rolls_back_the_import(monkeypatch):
    from content.models import Brand, Reviewer

    brands_before = Brand.all_objects.count()
    reviewers_before = Reviewer.objects.count()

    def fail_review_write(*args, **kwargs):
        raise RuntimeError("review write failed")

    monkeypatch.setattr(
        "content.management.commands.import_wp.Review.all_objects.bulk_create",
        fail_review_write,
    )

    with pytest.raises(RuntimeError, match="review write failed"):
        call_command("import_wp")

    assert Brand.all_objects.count() == brands_before
    assert Reviewer.objects.count() == reviewers_before


def _counts():
    from content.models import Brand, Industry, Page, Review, Reviewer

    return {
        "brands": Brand.objects.count(),
        "reviews": Review.all_objects.count(),
        "reviewers": Reviewer.objects.count(),
        "industries": Industry.objects.count(),
        "pages": Page.objects.count(),
    }


def _cache():
    from content.models import Brand

    return {
        brand.slug: (brand.average_rating, brand.review_count, brand.top_review.title)
        for brand in Brand.objects.order_by("slug")
    }


def _clear_imported():
    from content.models import Brand, Industry, Page, Review, Reviewer

    Review.all_objects.all().delete()
    Brand.objects.all().delete()
    Reviewer.objects.all().delete()
    Industry.objects.all().delete()
    Page.objects.all().delete()


def _prefix():
    return os.environ.get("WORDPRESS_TABLE_PREFIX", "wp_")


def _connect():
    return pymysql.connect(
        host=os.environ["WORDPRESS_DB_HOST"],
        port=int(os.environ.get("WORDPRESS_DB_PORT", "3306")),
        user=os.environ["WORDPRESS_DB_USER"],
        password=os.environ["WORDPRESS_DB_PASSWORD"],
        database="wp_test",
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=True,
    )


def _wp_user_id(login):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                f"SELECT ID FROM {prefix}users WHERE user_login = %s",
                [login],
            )
            return cursor.fetchone()["ID"]
    finally:
        connection.close()


def _post_id(cursor, post_name):
    cursor.execute(
        f"SELECT ID FROM {_prefix()}posts WHERE post_name = %s",
        [post_name],
    )
    return cursor.fetchone()["ID"]


@contextmanager
def _trashed_post(post_name):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            post_id = _post_id(cursor, post_name)
            cursor.execute(
                f"SELECT post_status FROM {prefix}posts WHERE ID = %s",
                [post_id],
            )
            original = cursor.fetchone()["post_status"]
            cursor.execute(
                f"UPDATE {prefix}posts SET post_status = 'trash' WHERE ID = %s",
                [post_id],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"UPDATE {prefix}posts SET post_status = %s WHERE ID = %s",
                    [original, post_id],
                )
    finally:
        connection.close()


@contextmanager
def _inserted_meta(post_name, meta_key, value):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            post_id = _post_id(cursor, post_name)
            cursor.execute(
                f"""
                INSERT INTO {prefix}postmeta (post_id, meta_key, meta_value)
                VALUES (%s, %s, %s)
                """,
                [post_id, meta_key, value],
            )
            meta_id = cursor.lastrowid
        try:
            yield post_id
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"DELETE FROM {prefix}postmeta WHERE meta_id = %s",
                    [meta_id],
                )
    finally:
        connection.close()


@contextmanager
def _replaced_meta(post_name, meta_key, value):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            post_id = _post_id(cursor, post_name)
            cursor.execute(
                f"""
                SELECT meta_value FROM {prefix}postmeta
                WHERE post_id = %s AND meta_key = %s
                """,
                [post_id, meta_key],
            )
            original = cursor.fetchone()["meta_value"]
            cursor.execute(
                f"""
                UPDATE {prefix}postmeta SET meta_value = %s
                WHERE post_id = %s AND meta_key = %s
                """,
                [value, post_id, meta_key],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"""
                    UPDATE {prefix}postmeta SET meta_value = %s
                    WHERE post_id = %s AND meta_key = %s
                    """,
                    [original, post_id, meta_key],
                )
    finally:
        connection.close()


@contextmanager
def _replaced_post_content(post_name, content):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            post_id = _post_id(cursor, post_name)
            cursor.execute(
                f"SELECT post_content FROM {prefix}posts WHERE ID = %s",
                [post_id],
            )
            original = cursor.fetchone()["post_content"]
            cursor.execute(
                f"UPDATE {prefix}posts SET post_content = %s WHERE ID = %s",
                [content, post_id],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"UPDATE {prefix}posts SET post_content = %s WHERE ID = %s",
                    [original, post_id],
                )
    finally:
        connection.close()


def _industry_link(cursor, post_name):
    prefix = _prefix()
    post_id = _post_id(cursor, post_name)
    cursor.execute(
        f"""
        SELECT tr.term_taxonomy_id
        FROM {prefix}term_relationships AS tr
        JOIN {prefix}term_taxonomy AS tt
          ON tt.term_taxonomy_id = tr.term_taxonomy_id
        WHERE tr.object_id = %s AND tt.taxonomy = 'industry'
        """,
        [post_id],
    )
    return post_id, cursor.fetchone()["term_taxonomy_id"]


@contextmanager
def _replaced_term_slug(term_id, slug):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                f"SELECT slug FROM {prefix}terms WHERE term_id = %s",
                [term_id],
            )
            original = cursor.fetchone()["slug"]
            cursor.execute(
                f"UPDATE {prefix}terms SET slug = %s WHERE term_id = %s",
                [slug, term_id],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"UPDATE {prefix}terms SET slug = %s WHERE term_id = %s",
                    [original, term_id],
                )
    finally:
        connection.close()


@contextmanager
def _replaced_term_name(term_id, name):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                f"SELECT name FROM {prefix}terms WHERE term_id = %s",
                [term_id],
            )
            original = cursor.fetchone()["name"]
            cursor.execute(
                f"UPDATE {prefix}terms SET name = %s WHERE term_id = %s",
                [name, term_id],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"UPDATE {prefix}terms SET name = %s WHERE term_id = %s",
                    [original, term_id],
                )
    finally:
        connection.close()


def _industry_terms():
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                f"""
                SELECT terms.term_id, terms.name, terms.slug
                FROM {prefix}terms AS terms
                JOIN {prefix}term_taxonomy AS taxonomy
                  ON taxonomy.term_id = terms.term_id
                WHERE taxonomy.taxonomy = 'industry'
                """
            )
            return list(cursor.fetchall())
    finally:
        connection.close()


def _term_taxonomy_id(cursor, slug):
    prefix = _prefix()
    cursor.execute(
        f"""
        SELECT tt.term_taxonomy_id
        FROM {prefix}term_taxonomy AS tt
        JOIN {prefix}terms AS terms ON terms.term_id = tt.term_id
        WHERE terms.slug = %s AND tt.taxonomy = 'industry'
        """,
        [slug],
    )
    return cursor.fetchone()["term_taxonomy_id"]


@contextmanager
def _moved_industry(post_name, slug):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            post_id, original = _industry_link(cursor, post_name)
            destination = _term_taxonomy_id(cursor, slug)
            cursor.execute(
                f"""
                UPDATE {prefix}term_relationships
                SET term_taxonomy_id = %s
                WHERE object_id = %s AND term_taxonomy_id = %s
                """,
                [destination, post_id, original],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"""
                    UPDATE {prefix}term_relationships
                    SET term_taxonomy_id = %s
                    WHERE object_id = %s AND term_taxonomy_id = %s
                    """,
                    [original, post_id, destination],
                )
    finally:
        connection.close()


@contextmanager
def _review_posted_before_its_brand():
    prefix = _prefix()
    connection = _connect()
    review_id = 90010
    brand_id = 90011
    author_id = _wp_user_id("sarah_k")

    def delete_rows():
        with connection.cursor() as cursor:
            cursor.execute(
                f"DELETE FROM {prefix}postmeta WHERE post_id IN (%s, %s)",
                [review_id, brand_id],
            )
            cursor.execute(
                f"DELETE FROM {prefix}posts WHERE ID IN (%s, %s)",
                [review_id, brand_id],
            )

    try:
        delete_rows()
        with connection.cursor() as cursor:
            _insert_published_post(
                cursor,
                brand_id,
                "brand",
                "later-brand",
                "Later Brand",
                0,
            )
            _insert_published_post(
                cursor,
                review_id,
                "review",
                "earlier-review",
                "Earlier Review",
                author_id,
            )
            cursor.execute(
                f"""
                INSERT INTO {prefix}postmeta (post_id, meta_key, meta_value)
                VALUES (%s, 'brand', %s), (%s, 'rating', '4')
                """,
                [review_id, str(brand_id), review_id],
            )
        yield review_id, brand_id
    finally:
        delete_rows()
        connection.close()


@contextmanager
def _ninth_review_author():
    prefix = _prefix()
    connection = _connect()
    user_id = 90020
    review_id = 90021
    login = "ninth_author"
    display_name = "Ninth Author"

    def delete_rows():
        with connection.cursor() as cursor:
            cursor.execute(
                f"DELETE FROM {prefix}postmeta WHERE post_id = %s",
                [review_id],
            )
            cursor.execute(f"DELETE FROM {prefix}posts WHERE ID = %s", [review_id])
            cursor.execute(f"DELETE FROM {prefix}users WHERE ID = %s", [user_id])

    try:
        delete_rows()
        with connection.cursor() as cursor:
            cursor.execute(
                f"""
                INSERT INTO {prefix}users (
                    ID, user_login, user_pass, user_nicename, user_email,
                    user_url, user_registered, user_activation_key, user_status,
                    display_name
                ) VALUES (
                    %s, %s, '', %s, %s,
                    '', '2026-05-19 20:29:13', '', 0, %s
                )
                """,
                [user_id, login, login, "ninth@example.com", display_name],
            )
            brand_id = _post_id(cursor, "acme-insurance")
            _insert_published_post(
                cursor,
                review_id,
                "review",
                "ninth-author-review",
                "Ninth Author Review",
                user_id,
            )
            cursor.execute(
                f"""
                INSERT INTO {prefix}postmeta (post_id, meta_key, meta_value)
                VALUES (%s, 'brand', %s), (%s, 'rating', '4')
                """,
                [review_id, str(brand_id), review_id],
            )
        yield {"wp_id": user_id, "display_name": display_name}
    finally:
        delete_rows()
        connection.close()


def _insert_published_post(cursor, post_id, post_type, slug, title, author_id):
    cursor.execute(
        f"""
        INSERT INTO {_prefix()}posts (
            ID, post_author, post_date, post_date_gmt, post_content, post_title,
            post_excerpt, post_status, post_name, to_ping, pinged,
            post_content_filtered, post_type
        ) VALUES (
            %s, %s, '2026-05-19 20:29:13', '2026-05-19 20:29:13', %s, %s,
            '', 'publish', %s, '', '',
            '', %s
        )
        """,
        [post_id, author_id, f"<p>{title}</p>", title, slug, post_type],
    )


@contextmanager
def _taxonomy_mismatch(post_name, slug):
    prefix = _prefix()
    connection = _connect()
    try:
        with connection.cursor() as cursor:
            post_id, original = _industry_link(cursor, post_name)
            if _term_taxonomy_id(cursor, slug) != original:
                raise AssertionError("linked industry is not the slug's term_taxonomy_id")
            cursor.execute(
                f"""
                INSERT INTO {prefix}terms (term_id, name, slug, term_group)
                VALUES (%s, %s, %s, 0)
                """,
                [MISMATCH_ID, "Decoy", "decoy-industry"],
            )
            cursor.execute(
                f"""
                UPDATE {prefix}term_taxonomy
                SET term_taxonomy_id = %s
                WHERE term_taxonomy_id = %s
                """,
                [MISMATCH_ID, original],
            )
            cursor.execute(
                f"""
                UPDATE {prefix}term_relationships
                SET term_taxonomy_id = %s
                WHERE object_id = %s AND term_taxonomy_id = %s
                """,
                [MISMATCH_ID, post_id, original],
            )
        try:
            yield
        finally:
            with connection.cursor() as cursor:
                cursor.execute(
                    f"""
                    UPDATE {prefix}term_relationships
                    SET term_taxonomy_id = %s
                    WHERE object_id = %s AND term_taxonomy_id = %s
                    """,
                    [original, post_id, MISMATCH_ID],
                )
                cursor.execute(
                    f"""
                    UPDATE {prefix}term_taxonomy
                    SET term_taxonomy_id = %s
                    WHERE term_taxonomy_id = %s
                    """,
                    [original, MISMATCH_ID],
                )
                cursor.execute(
                    f"DELETE FROM {prefix}terms WHERE term_id = %s",
                    [MISMATCH_ID],
                )
    finally:
        connection.close()
