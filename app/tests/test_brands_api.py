from datetime import datetime, timezone

import pytest
from django.core.management import call_command
from django.db import connection
from django.test.utils import CaptureQueriesContext
from rest_framework.test import APIClient

pytestmark = pytest.mark.django_db(databases=["default"])

PUBLISHED_AT = datetime(2024, 6, 1, 12, 0, tzinfo=timezone.utc)
DEFAULT_NAMES = [
    "Acme Insurance Co.",
    "PrimePath Bank",
    "UrbanRetail Co.",
    "SwiftStream Internet",
    "HomeShield Pro",
]
EQUAL_REVIEW_SLUGS = [
    "acme-insurance",
    "homeshield-pro",
    "primepath-bank",
    "swiftstream-internet",
    "urbanretail-co",
]
TOP_REVIEW_TITLES = {
    "acme-insurance": "Fine but nothing special",
    "primepath-bank": "Quick HELOC approval",
    "homeshield-pro": "Contractor quality is inconsistent",
    "swiftstream-internet": "Equipment fee feels excessive",
    "urbanretail-co": "Return policy is generous, with caveats",
}
INDUSTRY_SLUGS = {
    "acme-insurance": "insurance",
    "primepath-bank": "finance",
    "homeshield-pro": "home-services",
    "swiftstream-internet": "telecom",
    "urbanretail-co": "retail",
}
RESULT_FIELDS = {
    "name",
    "slug",
    "industry",
    "average_rating",
    "review_count",
    "short_description",
    "top_review",
}
TOP_REVIEW_FIELDS = {"slug", "title", "rating", "reviewer_name", "snippet"}


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


def test_unpublished_brand_is_absent_from_the_public_manager_and_the_api():
    from content.models import Brand

    make_brand(wp_id=1, slug="published-brand", title="Published", is_published=True)
    make_brand(wp_id=2, slug="draft-brand", title="Draft", is_published=False)

    assert set(Brand.objects.values_list("slug", flat=True)) == {"published-brand"}
    response = APIClient().get("/api/brands/")
    assert response.status_code == 200
    assert {row["slug"] for row in response.json()["results"]} == {"published-brand"}
    assert set(Brand.all_objects.values_list("slug", flat=True)) == {
        "published-brand",
        "draft-brand",
    }


def test_page_size_1000_returns_at_most_50():
    for number in range(60):
        make_brand(wp_id=number + 1, slug=f"brand-{number:02d}", title=f"Brand {number}")

    client = APIClient()
    capped = client.get("/api/brands/?page_size=1000")
    assert capped.status_code == 200
    body = capped.json()
    assert set(body) == {"count", "next", "previous", "results"}
    assert body["count"] == 60
    assert len(body["results"]) == 50

    default = client.get("/api/brands/")
    assert default.status_code == 200
    assert len(default.json()["results"]) == 12

    assert client.get("/api/brands/?page=999").status_code == 404


def test_no_params_returns_acme_primepath_urbanretail_swiftstream_homeshield():
    call_command("import_wp")

    response = APIClient().get("/api/brands/")
    assert response.status_code == 200
    body = response.json()
    assert body["count"] == 5
    assert body["next"] is None
    assert body["previous"] is None
    results = body["results"]
    assert [row["name"] for row in results] == DEFAULT_NAMES
    assert [row["slug"] for row in results] == [
        "acme-insurance",
        "primepath-bank",
        "urbanretail-co",
        "swiftstream-internet",
        "homeshield-pro",
    ]
    for row in results:
        assert set(row) == RESULT_FIELDS
        assert "industries" not in row
        assert "headquarters" not in row
        assert row["industry"]["slug"] == INDUSTRY_SLUGS[row["slug"]]
        assert set(row["industry"]) == {"slug", "name"}


def test_sort_reviews_matches_when_every_brand_has_the_same_count():
    call_command("import_wp")
    client = APIClient()

    ascending = client.get("/api/brands/?sort=reviews")
    descending = client.get("/api/brands/?sort=-reviews")
    assert ascending.status_code == 200
    assert descending.status_code == 200
    assert [row["slug"] for row in ascending.json()["results"]] == EQUAL_REVIEW_SLUGS
    assert [row["slug"] for row in descending.json()["results"]] == EQUAL_REVIEW_SLUGS


def test_sort_reviews_reverses_when_counts_are_2_and_9():
    few = make_brand(wp_id=1, slug="few", title="Few")
    many = make_brand(wp_id=2, slug="many", title="Many")
    reviewer = make_reviewer()
    for number in range(2):
        make_review(few, reviewer, wp_id=number + 1, slug=f"few-{number}")
    for number in range(9):
        make_review(many, reviewer, wp_id=number + 10, slug=f"many-{number}", rating=4)

    client = APIClient()
    ascending = client.get("/api/brands/?sort=reviews")
    descending = client.get("/api/brands/?sort=-reviews")
    assert [row["slug"] for row in ascending.json()["results"]] == ["few", "many"]
    assert [row["slug"] for row in descending.json()["results"]] == ["many", "few"]


def test_industry_filter_is_or_once_and_unknown_sort_or_industry_is_400():
    call_command("import_wp")
    from content.models import Industry

    both = make_brand(wp_id=90001, slug="both-markets", title="Both Markets")
    finance = Industry.objects.get(slug="finance")
    retail = Industry.objects.get(slug="retail")
    both.industries.add(finance, retail)

    client = APIClient()
    response = client.get("/api/brands/?industry=finance,retail")
    assert response.status_code == 200
    slugs = [row["slug"] for row in response.json()["results"]]
    assert slugs.count("both-markets") == 1
    assert set(slugs) == {"primepath-bank", "urbanretail-co", "both-markets"}

    assert client.get("/api/brands/?sort=title").status_code == 400
    assert client.get("/api/brands/?industry=not-a-real-industry").status_code == 400
    assert client.get("/api/brands/?industry=finance,not-a-real-industry").status_code == 400


def test_brands_list_returns_the_stored_industry_name():
    from content.models import Industry
    from tests.test_import_wp import _replaced_term_name

    call_command("import_wp")
    industry = Industry.objects.get(slug="home-services")

    with _replaced_term_name(industry.wp_id, "Home & services"):
        call_command("import_wp")
        response = APIClient().get("/api/brands/")

    assert response.status_code == 200
    rows = {row["slug"]: row for row in response.json()["results"]}
    assert rows["homeshield-pro"]["industry"]["slug"] == "home-services"
    assert rows["homeshield-pro"]["industry"]["name"] == "Home & services"
    assert rows["acme-insurance"]["industry"]["name"] == "Insurance"
    assert rows["primepath-bank"]["industry"]["name"] == "Finance"
    assert rows["swiftstream-internet"]["industry"]["name"] == "Telecom"
    assert rows["urbanretail-co"]["industry"]["name"] == "Retail"


def test_industry_is_the_lowest_wp_id_or_null():
    from content.models import Industry

    finance = Industry.objects.create(wp_id=1, slug="finance")
    retail = Industry.objects.create(wp_id=8, slug="retail")
    both = make_brand(wp_id=1, slug="both", title="Both")
    both.industries.add(retail, finance)
    make_brand(wp_id=2, slug="none", title="None")

    response = APIClient().get("/api/brands/")
    assert response.status_code == 200
    rows = {row["slug"]: row for row in response.json()["results"]}
    assert rows["both"]["industry"]["slug"] == "finance"
    assert set(rows["both"]["industry"]) == {"slug", "name"}
    assert rows["none"]["industry"] is None


def test_top_review_titles_match_and_a_brand_without_published_reviews_is_null():
    call_command("import_wp")
    bare = make_brand(wp_id=90001, slug="no-reviews", title="No Reviews")
    make_review(
        bare,
        make_reviewer(wp_id=90001),
        wp_id=90001,
        slug="hidden-review",
        title="Should not be the top review",
        is_published=False,
    )

    response = APIClient().get("/api/brands/")
    assert response.status_code == 200
    rows = {row["slug"]: row for row in response.json()["results"]}
    assert {
        slug: rows[slug]["top_review"]["title"] for slug in TOP_REVIEW_TITLES
    } == TOP_REVIEW_TITLES
    acme = rows["acme-insurance"]["top_review"]
    assert set(acme) == TOP_REVIEW_FIELDS
    assert isinstance(acme["rating"], int)
    assert rows["no-reviews"]["top_review"] is None


def test_acme_average_is_3_92_and_swiftstream_average_is_3_5():
    call_command("import_wp")

    response = APIClient().get("/api/brands/")
    assert response.status_code == 200
    rows = {row["slug"]: row for row in response.json()["results"]}
    assert rows["acme-insurance"]["average_rating"] == 3.92
    assert isinstance(rows["acme-insurance"]["average_rating"], float)
    assert rows["swiftstream-internet"]["average_rating"] == 3.5
    assert isinstance(rows["swiftstream-internet"]["average_rating"], float)


def test_snippet_is_the_first_24_words_of_stripped_html_and_marks_a_cut():
    brand = make_brand()
    reviewer = make_reviewer()
    words = [f"w{number}" for number in range(1, 26)]
    make_review(
        brand,
        reviewer,
        body="<div>" + " ".join(f"<span>{word}</span>" for word in words) + "</div>",
        title="Long review",
        slug="long-review",
    )
    short = make_brand(wp_id=2, slug="short-brand", title="Short Brand")
    make_review(
        short,
        reviewer,
        wp_id=2,
        slug="short-review",
        title="Short review",
        body="<p>kept <b>whole</b> sentence</p>",
    )

    response = APIClient().get("/api/brands/")
    assert response.status_code == 200
    rows = {row["slug"]: row for row in response.json()["results"]}
    assert rows["acme"]["top_review"]["snippet"] == " ".join(words[:24]) + "…"
    assert rows["short-brand"]["top_review"]["snippet"] == "kept whole sentence"


def test_listing_does_not_query_industries_once_per_row():
    call_command("import_wp")
    client = APIClient()

    with CaptureQueriesContext(connection) as captured:
        response = client.get("/api/brands/")

    assert response.status_code == 200
    results = response.json()["results"]
    assert len(results) > 1
    industry_queries = [
        query for query in captured.captured_queries if "content_industry" in query["sql"]
    ]
    assert len(industry_queries) == 1


def make_brand(**overrides):
    from content.models import Brand

    fields = {"wp_id": 1, "slug": "acme", "title": "Acme", "is_published": True}
    fields.update(overrides)
    return Brand.objects.create(**fields)


def make_reviewer(**overrides):
    from content.models import Reviewer
    from uuid import uuid4

    fields = {"wp_id": 1, "public_id": uuid4(), "display_name": "Sarah"}
    fields.update(overrides)
    return Reviewer.objects.create(**fields)


def make_review(brand, reviewer, **overrides):
    from content.models import Review

    fields = {
        "wp_id": 1,
        "slug": "review-1",
        "title": "Solid",
        "body": "Worked as expected.",
        "rating": 5,
        "reviewer": reviewer,
        "reviewer_location": "Austin, TX",
        "published_at": PUBLISHED_AT,
        "brand": brand,
        "is_published": True,
    }
    fields.update(overrides)
    return Review.all_objects.create(**fields)
