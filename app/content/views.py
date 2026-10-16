import re
from decimal import ROUND_HALF_UP, Decimal
from urllib.parse import urlparse

from django.core.paginator import InvalidPage, Paginator
from django.http import Http404
from django.shortcuts import get_object_or_404, redirect, render
from rest_framework.exceptions import ValidationError
from rest_framework.generics import ListAPIView
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework.views import APIView
from shared_auth.claims import BRANDS_EDIT
from shared_auth.drf import Authentication, HasPermission

from content.models import Brand, Industry, Page, Review
from content.serializers import BrandSerializer, BrandShortDescriptionSerializer

_SORT_COLUMNS = {
    "rating": "average_rating",
    "reviews": "review_count",
}


class BrandPagination(PageNumberPagination):
    page_size = 12
    page_size_query_param = "page_size"
    max_page_size = 50


class BrandListView(ListAPIView):
    serializer_class = BrandSerializer
    pagination_class = BrandPagination

    def get_queryset(self):
        params = self.request.query_params
        queryset = _filter_industry(Brand.objects.all(), params.get("industry"))
        return (
            queryset.select_related("top_review", "top_review__reviewer")
            .prefetch_related("industries")
            .order_by(*_ordering(params.get("sort")))
        )


def _ordering(sort):
    if sort is None:
        return ("-average_rating", "slug")
    descending = sort.startswith("-")
    column = _SORT_COLUMNS.get(sort[1:] if descending else sort)
    if column is None:
        raise ValidationError("Unknown sort.")
    prefix = "-" if descending else ""
    return (f"{prefix}{column}", "slug")


def _filter_industry(queryset, raw):
    if raw is None:
        return queryset
    slugs = raw.split(",")
    found = set(Industry.objects.filter(slug__in=slugs).values_list("slug", flat=True))
    if not slugs or found != set(slugs):
        raise ValidationError("Unknown industry.")
    matching = Brand.objects.filter(industries__slug__in=slugs).values("pk")
    return queryset.filter(pk__in=matching)


class BrandPatchView(APIView):
    authentication_classes = [Authentication]
    permission_classes = [HasPermission(BRANDS_EDIT)]

    def patch(self, request, slug):
        brand = get_object_or_404(Brand, slug=slug)
        serializer = BrandShortDescriptionSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        brand.short_description = serializer.validated_data["short_description"]
        brand.save(update_fields=["short_description"])
        return Response({"short_description": brand.short_description})


def brand_page(request, slug):
    brand = get_object_or_404(Brand.objects.prefetch_related("industries"), slug=slug)
    industries = list(brand.industries.all())
    reviews = [
        {
            "title": review.title,
            "slug": review.slug,
            "body": review.body,
            "reviewer_name": review.reviewer.display_name,
            "reviewer_location": review.reviewer_location,
            "published_at": review.published_at,
            "stars": _stars(review.rating, show_value=False),
        }
        for review in (
            Review.objects.filter(brand=brand)
            .select_related("reviewer")
            .order_by("-published_at")
        )
    ]
    return render(
        request,
        "content/brand_detail.html",
        {
            "brand": brand,
            "industry": min(industries, key=lambda row: row.name).name if industries else None,
            "website_host": urlparse(brand.website_url).hostname or "",
            "stars": (
                _stars(brand.average_rating, show_value=True)
                if brand.average_rating is not None
                else None
            ),
            "reviews": reviews,
        },
    )


def home(request):
    industries = (
        Industry.objects.filter(brands__is_published=True).distinct().order_by("slug")
    )
    return render(
        request,
        "content/home.html",
        {
            "industries": [
                {"slug": industry.slug, "name": industry.name} for industry in industries
            ]
        },
    )


def _stars(rating, show_value):
    value = Decimal(rating)
    halves = int((value * 2).quantize(Decimal("1"), rounding=ROUND_HALF_UP))
    full, half = divmod(max(0, min(10, halves)), 2)
    label = format(value.quantize(Decimal("0.1"), rounding=ROUND_HALF_UP), "f")
    return {
        "full": range(full),
        "half": bool(half),
        "empty": range(5 - full - half),
        "label": label,
        "show_value": show_value,
    }


def review_page(request, slug):
    review = get_object_or_404(
        Review.objects.select_related("brand", "reviewer"),
        slug=slug,
    )
    return render(
        request,
        "content/review_detail.html",
        {
            "review": review,
            "stars": _stars(review.rating, show_value=True),
        },
    )


def review_archive(request, number=None):
    if number == 1:
        return redirect("/review/", permanent=True)
    if number is not None and number < 1:
        raise Http404
    paginator = Paginator(
        Review.objects.select_related("brand", "reviewer").order_by("-published_at", "wp_id"),
        10,
    )
    try:
        page = paginator.page(1 if number is None else number)
    except InvalidPage:
        raise Http404
    return render(
        request,
        "content/review_archive.html",
        {
            "page": page,
            "reviews": [_archive_card(review) for review in page.object_list],
        },
    )


def _archive_card(review):
    name = review.reviewer.display_name
    if review.reviewer_location:
        byline = f"{name}, {review.reviewer_location}"
    else:
        byline = name
    return {
        "title": review.title,
        "slug": review.slug,
        "brand_title": review.brand.title,
        "brand_slug": review.brand.slug,
        "excerpt": _review_excerpt(review.body),
        "published_at": review.published_at,
        "byline": byline,
        "stars": _stars(review.rating, show_value=False),
    }


def about_page(request):
    page = get_object_or_404(Page, slug="about", is_published=True)
    return render(request, "content/about.html", {"page": page})


_EXCERPT_WORDS = 40


def _review_excerpt(html):
    text = re.sub(r"(?is)<(script|style)\b[^>]*>.*?</\1>", "", html or "")
    text = re.sub(r"<[^>]+>", "", text).strip()
    words = [word for word in re.split(r"[\n\r\t ]+", text) if word]
    if len(words) <= _EXCERPT_WORDS:
        return " ".join(words)
    return " ".join(words[:_EXCERPT_WORDS]) + "…"


def brand_archive(request):
    industries = (
        Industry.objects.filter(brands__is_published=True).distinct().order_by("slug")
    )
    return render(
        request,
        "content/brand_archive.html",
        {
            "industries": [
                {"slug": industry.slug, "name": industry.name}
                for industry in industries
            ]
        },
    )
