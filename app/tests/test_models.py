from datetime import datetime, timedelta, timezone
from decimal import Decimal
from uuid import uuid4

import pytest
from django.core.exceptions import ValidationError
from django.db import IntegrityError, transaction

pytestmark = pytest.mark.django_db(databases=["default"])

PUBLISHED_AT = datetime(2024, 6, 1, 12, 0, tzinfo=timezone.utc)


def make_brand(**overrides):
    from content.models import Brand

    fields = {"wp_id": 1, "slug": "acme", "title": "Acme", "is_published": True}
    fields.update(overrides)
    return Brand.objects.create(**fields)


def make_reviewer(**overrides):
    from content.models import Reviewer

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


def test_reviewer_public_id_is_unique():
    shared = uuid4()
    make_reviewer(public_id=shared)
    with pytest.raises(IntegrityError):
        with transaction.atomic():
            make_reviewer(wp_id=2, public_id=shared, display_name="Mike")


def test_creating_deleting_or_changing_a_rating_updates_the_brand_and_moving_updates_both():
    from content.models import Review

    source = make_brand()
    dest = make_brand(wp_id=2, slug="other")
    reviewer = make_reviewer()
    review = make_review(source, reviewer, rating=5)

    source.refresh_from_db()
    assert source.review_count == 1
    assert source.average_rating == Decimal("5.00")
    assert source.top_review_id == review.id

    review.rating = 2
    review.save()
    source.refresh_from_db()
    assert source.review_count == 1
    assert source.average_rating == Decimal("2.00")
    assert source.top_review_id == review.id

    review.brand = dest
    review.save()
    source.refresh_from_db()
    dest.refresh_from_db()
    assert source.review_count == 0
    assert source.average_rating is None
    assert source.top_review_id is None
    assert dest.review_count == 1
    assert dest.average_rating == Decimal("2.00")
    assert dest.top_review_id == review.id

    review.delete()
    dest.refresh_from_db()
    assert dest.review_count == 0
    assert dest.average_rating is None
    assert dest.top_review_id is None
    assert Review.all_objects.filter(pk=review.pk).exists() is False


def test_unpublished_reviews_are_excluded_from_the_cache_and_public_manager():
    from content.models import Review

    brand = make_brand()
    reviewer = make_reviewer()
    published = make_review(brand, reviewer, wp_id=1, slug="published", rating=5)
    make_review(
        brand,
        reviewer,
        wp_id=2,
        slug="draft",
        rating=1,
        is_published=False,
    )

    brand.refresh_from_db()
    assert brand.review_count == 1
    assert brand.average_rating == Decimal("5.00")
    assert brand.top_review_id == published.id

    hidden_brand = make_brand(wp_id=2, slug="hidden", is_published=False)
    hidden_review = make_review(
        hidden_brand,
        reviewer,
        wp_id=3,
        slug="hidden-review",
        rating=4,
        is_published=True,
    )
    assert Review.objects.filter(pk=hidden_review.pk).exists() is False
    assert Review.all_objects.filter(pk=hidden_review.pk).exists() is True
    assert Review.objects.filter(pk=published.pk).exists() is True


def test_recalculate_queries_avg_and_count():
    from django.db import connection
    from django.test.utils import CaptureQueriesContext

    from content.models import recalculate_brand_stats

    brand = make_brand()
    reviewer = make_reviewer()
    make_review(brand, reviewer, rating=4)

    with CaptureQueriesContext(connection) as captured:
        recalculate_brand_stats([brand.pk])

    sql = " ".join(query["sql"] for query in captured.captured_queries)
    assert "AVG(" in sql
    assert "COUNT(" in sql


def test_queryset_update_and_delete_leave_the_cache_stale_until_recalculate():
    from content.models import Review, recalculate_brand_stats

    brand = make_brand()
    reviewer = make_reviewer()
    first = make_review(brand, reviewer, wp_id=1, slug="first", rating=5)
    second = make_review(brand, reviewer, wp_id=2, slug="second", rating=3)
    brand.refresh_from_db()
    assert brand.review_count == 2
    assert brand.average_rating == Decimal("4.00")

    Review.objects.filter(pk=first.pk).update(rating=1)
    brand.refresh_from_db()
    assert brand.review_count == 2
    assert brand.average_rating == Decimal("4.00")

    recalculate_brand_stats([brand.pk])
    brand.refresh_from_db()
    assert brand.review_count == 2
    assert brand.average_rating == Decimal("2.00")

    Review.objects.filter(pk=second.pk).delete()
    brand.refresh_from_db()
    assert brand.review_count == 2
    assert brand.average_rating == Decimal("2.00")

    recalculate_brand_stats([brand.pk])
    brand.refresh_from_db()
    assert brand.review_count == 1
    assert brand.average_rating == Decimal("1.00")
    assert brand.top_review_id == first.id


def test_same_distance_and_published_at_higher_wp_id_wins():
    brand = make_brand()
    reviewer = make_reviewer()
    make_review(
        brand,
        reviewer,
        wp_id=10,
        slug="lower",
        rating=1,
        published_at=PUBLISHED_AT,
    )
    higher = make_review(
        brand,
        reviewer,
        wp_id=20,
        slug="higher",
        rating=5,
        published_at=PUBLISHED_AT,
    )

    brand.refresh_from_db()
    assert brand.average_rating == Decimal("3.00")
    assert brand.top_review_id == higher.id

    newer = make_review(
        brand,
        reviewer,
        wp_id=5,
        slug="newer",
        rating=1,
        published_at=PUBLISHED_AT + timedelta(days=1),
    )
    brand.refresh_from_db()
    assert brand.top_review_id == newer.id


def test_rating_rejects_a_value_outside_1_to_5():
    brand = make_brand()
    reviewer = make_reviewer()
    review = make_review(brand, reviewer, rating=3)

    review.rating = 0
    with pytest.raises(ValidationError):
        review.full_clean()

    review.rating = 6
    with pytest.raises(ValidationError):
        review.full_clean()


def test_brand_can_have_two_industries():
    from content.models import Industry

    brand = make_brand()
    banking = Industry.objects.create(wp_id=1, slug="banking")
    insurance = Industry.objects.create(wp_id=2, slug="insurance")
    brand.industries.add(banking, insurance)

    assert set(brand.industries.values_list("slug", flat=True)) == {
        "banking",
        "insurance",
    }
