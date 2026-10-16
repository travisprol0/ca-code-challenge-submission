import re

from rest_framework import serializers

_SNIPPET_WORDS = 24


class BrandSerializer(serializers.Serializer):
    name = serializers.CharField(source="title")
    slug = serializers.CharField()
    industry = serializers.SerializerMethodField()
    average_rating = serializers.DecimalField(
        max_digits=3, decimal_places=2, coerce_to_string=False, allow_null=True
    )
    review_count = serializers.IntegerField()
    short_description = serializers.CharField(allow_blank=True)
    top_review = serializers.SerializerMethodField()

    def get_industry(self, brand):
        industries = list(brand.industries.all())
        if not industries:
            return None
        industry = min(industries, key=lambda row: row.wp_id)
        return {"slug": industry.slug, "name": industry.name}

    def get_top_review(self, brand):
        review = brand.top_review
        if review is None:
            return None
        return {
            "slug": review.slug,
            "title": review.title,
            "rating": review.rating,
            "reviewer_name": review.reviewer.display_name,
            "snippet": review_snippet(review.body),
        }


class BrandShortDescriptionSerializer(serializers.Serializer):
    short_description = serializers.CharField(allow_blank=True, trim_whitespace=False)

    def to_internal_value(self, data):
        if not isinstance(data, dict):
            raise serializers.ValidationError({"non_field_errors": ["Expected an object."]})
        if set(data) - {"short_description"}:
            raise serializers.ValidationError({"non_field_errors": ["Unexpected field."]})
        return super().to_internal_value(data)


def review_snippet(html):
    text = re.sub(r"(?is)<(script|style)\b[^>]*>.*?</\1>", "", html or "")
    text = re.sub(r"<[^>]+>", "", text).strip()
    words = [word for word in re.split(r"[\n\r\t ]+", text) if word]
    if len(words) <= _SNIPPET_WORDS:
        return " ".join(words)
    return " ".join(words[:_SNIPPET_WORDS]) + "…"
