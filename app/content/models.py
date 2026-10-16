from decimal import Decimal

from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.db.models import Avg, Count, DecimalField


class Industry(models.Model):
    wp_id = models.PositiveIntegerField(unique=True)
    slug = models.CharField(max_length=200, unique=True)
    name = models.CharField(max_length=200)


class Reviewer(models.Model):
    wp_id = models.PositiveIntegerField(unique=True)
    public_id = models.UUIDField(unique=True)
    display_name = models.CharField(max_length=200)


class PublishedBrandManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(is_published=True)


class Brand(models.Model):
    wp_id = models.PositiveIntegerField(unique=True)
    slug = models.CharField(max_length=200, unique=True)
    title = models.CharField(max_length=200)
    is_published = models.BooleanField(default=False)
    website_url = models.URLField(max_length=200, blank=True)
    founded_year = models.PositiveIntegerField(
        null=True,
        blank=True,
        validators=[MinValueValidator(1800), MaxValueValidator(2100)],
    )
    headquarters = models.CharField(max_length=200, blank=True)
    seo_title = models.CharField(max_length=200, blank=True)
    seo_description = models.TextField(blank=True)
    short_description = models.TextField(blank=True)
    body = models.TextField(blank=True)
    industries = models.ManyToManyField("Industry", blank=True, related_name="brands")
    average_rating = models.DecimalField(
        max_digits=3, decimal_places=2, null=True, blank=True
    )
    review_count = models.PositiveIntegerField(default=0)
    top_review = models.ForeignKey(
        "Review",
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name="+",
    )

    objects = PublishedBrandManager()
    all_objects = models.Manager()

    class Meta:
        constraints = [
            models.CheckConstraint(
                condition=models.Q(founded_year__isnull=True)
                | models.Q(founded_year__gte=1800, founded_year__lte=2100),
                name="brand_founded_year_in_range",
            )
        ]


class PublishedReviewManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(is_published=True, brand__is_published=True)


class Review(models.Model):
    wp_id = models.PositiveIntegerField(unique=True)
    slug = models.CharField(max_length=200, unique=True)
    title = models.CharField(max_length=200)
    body = models.TextField(blank=True)
    rating = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    reviewer = models.ForeignKey("Reviewer", on_delete=models.PROTECT, related_name="reviews")
    reviewer_location = models.CharField(max_length=200, blank=True)
    published_at = models.DateTimeField()
    brand = models.ForeignKey("Brand", on_delete=models.CASCADE, related_name="reviews")
    is_published = models.BooleanField(default=False)

    objects = PublishedReviewManager()
    all_objects = models.Manager()

    class Meta:
        constraints = [
            models.CheckConstraint(
                condition=models.Q(rating__gte=1, rating__lte=5),
                name="review_rating_between_1_and_5",
            )
        ]

    def save(self, *args, **kwargs):
        previous_brand_id = None
        if self.pk:
            previous_brand_id = (
                Review.all_objects.filter(pk=self.pk)
                .values_list("brand_id", flat=True)
                .first()
            )
        super().save(*args, **kwargs)
        recalculate_brand_stats([previous_brand_id, self.brand_id])

    def delete(self, *args, **kwargs):
        brand_id = self.brand_id
        result = super().delete(*args, **kwargs)
        recalculate_brand_stats([brand_id])
        return result


class Page(models.Model):
    wp_id = models.PositiveIntegerField(unique=True)
    slug = models.CharField(max_length=200, unique=True)
    title = models.CharField(max_length=200)
    body = models.TextField(blank=True)
    is_published = models.BooleanField(default=False)


def recalculate_brand_stats(brand_ids):
    ids = {brand_id for brand_id in brand_ids if brand_id is not None}
    if not ids:
        return
    published = Review.all_objects.filter(brand_id__in=ids, is_published=True)
    aggregates = {
        row["brand_id"]: row
        for row in published.values("brand_id").annotate(
            average=Avg("rating", output_field=DecimalField(max_digits=10, decimal_places=4)),
            count=Count("pk"),
        )
    }
    reviews_by_brand = {}
    for review in published:
        reviews_by_brand.setdefault(review.brand_id, []).append(review)
    for brand in Brand.all_objects.filter(pk__in=ids):
        row = aggregates.get(brand.pk)
        rows = reviews_by_brand.get(brand.pk, [])
        if row is None or not rows:
            brand.average_rating = None
            brand.review_count = 0
            brand.top_review = None
        else:
            average = Decimal(row["average"]).quantize(Decimal("0.01"))
            brand.average_rating = average
            brand.review_count = row["count"]
            brand.top_review = min(rows, key=_top_review_key(average))
        brand.save(update_fields=["average_rating", "review_count", "top_review"])


def _top_review_key(average):
    def key(review):
        return (
            abs(Decimal(review.rating) - average),
            -review.published_at.timestamp(),
            -review.wp_id,
        )

    return key
