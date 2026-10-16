from datetime import datetime, timezone
from decimal import Decimal
from html.parser import HTMLParser
from uuid import uuid4

import pytest
from django.core.management import call_command
from django.test import Client

pytestmark = pytest.mark.django_db(databases=["default"])

ACME_REVIEW_TITLES = [
    "Fine but nothing special",
    "Discount for safe driving was real",
    "Glass claim handling was confusing",
    "Umbrella policy was easy to add",
    "Online portal feels like 2010",
    "Quick payout on a totaled vehicle",
    "Long hold times on the support line",
    "Bundled home and auto, saved real money",
    "Renewal sticker shock with no explanation",
    "Agent was a lifesaver during the storm",
    "Decent coverage but pricey for younger drivers",
    "Smooth auto claim after a parking-lot fender bender",
]
SECTION_CLASSES = {
    "brand-hero",
    "brand-meta",
    "brand-body",
    "reviews-section",
    "review-item",
}


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


def test_acme_brand_page_shows_insurance_host_count_and_dates():
    call_command("import_wp")
    response = Client().get("/brand/acme-insurance/")
    assert response.status_code == 200
    html = response.content.decode()
    page = _page(html)

    assert page.extends_base is True
    assert page.classes == SECTION_CLASSES
    assert page.hero_paragraphs[0] == "Insurance"
    assert page.meta_inside_hero is True
    assert page.meta_text == "acme-insurance.example.com 1985 Hartford, CT 12"
    assert 'class="container"' in html
    assert 'class="content"' in html
    assert page.website == {
        "href": "https://acme-insurance.example.com",
        "rel": "nofollow noopener",
        "target": "_blank",
        "text": "acme-insurance.example.com",
    }
    assert page.aria_labels[0] == "Rating: 3.9 out of 5"
    assert page.average_label == "3.9"
    assert page.glyph_hidden == ["true"] * (5 + 12 * 5)
    assert page.review_titles == ACME_REVIEW_TITLES
    assert page.review_dates == ["May 19, 2026"] * 12
    assert html.count("May 19, 2026") == 12


def test_brand_page_review_links_reviewer_and_body():
    from content.models import Review

    call_command("import_wp")
    review = Review.objects.select_related("reviewer").get(slug="fine-but-nothing-special")
    raw = Client().get("/brand/acme-insurance/").content.decode()
    marker = f'<h2><a href="/review/{review.slug}/">{review.title}</a></h2>'
    assert marker in raw
    start = raw.index(marker)
    card = raw[start : raw.index("</article>", start)]
    assert f"{review.reviewer.display_name}, {review.reviewer_location}" in card
    assert "I've had Acme for three years." in card
    assert review.body in card


def test_brand_page_uses_cached_review_count():
    brand = make_brand(review_count=99, average_rating=Decimal("4.50"))
    response = Client().get(f"/brand/{brand.slug}/")
    assert response.status_code == 200
    page = _page(response.content.decode())
    assert page.meta_text == "counted.example.com 2001 Austin, TX 99"
    assert page.review_dates == []


def test_brand_page_industry_is_first_by_name():
    from content.models import Industry

    home = Industry.objects.create(wp_id=1, slug="home-services", name="Home Services")
    finance = Industry.objects.create(wp_id=2, slug="finance", name="Finance")
    brand = make_brand(title="Dual", average_rating=Decimal("4.00"))
    brand.industries.add(home, finance)

    response = Client().get(f"/brand/{brand.slug}/")
    assert response.status_code == 200
    html = response.content.decode()
    page = _page(html)
    assert page.hero_paragraphs == ["Finance"]
    assert "Home Services" not in html


def test_brand_page_escapes_short_description_and_renders_body_html():
    brand = make_brand(
        short_description="<script>",
        body="<em>kept</em>",
        average_rating=Decimal("4.00"),
    )
    response = Client().get(f"/brand/{brand.slug}/")
    assert response.status_code == 200
    html = response.content.decode()
    page = _page(html)
    assert page.body_html == "<em>kept</em>"
    assert page.hero_paragraphs[-1] == "<script>"
    assert "&lt;script&gt;" in html
    assert "<script>" not in html


def test_unpublished_brand_slug_404s():
    from content.models import Brand, Review, Reviewer

    brand = Brand.all_objects.create(
        wp_id=1,
        slug="hidden-brand",
        title="Hidden",
        is_published=False,
        average_rating=Decimal("4.00"),
    )
    reviewer = Reviewer.objects.create(wp_id=1, public_id=uuid4(), display_name="Sam")
    Review.all_objects.create(
        wp_id=1,
        slug="visible-review",
        title="Visible review",
        body="Published text.",
        rating=5,
        reviewer=reviewer,
        published_at=datetime(2026, 5, 19, tzinfo=timezone.utc),
        brand=brand,
        is_published=True,
    )

    response = Client().get("/brand/hidden-brand/")
    assert response.status_code == 404
    assert "Visible review" not in response.content.decode()
    assert "Published text." not in response.content.decode()


class _BrandPage(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.extends_base = False
        self.classes = set()
        self.hero_paragraphs = []
        self.meta_inside_hero = False
        self.meta_text = ""
        self.website = None
        self.aria_labels = []
        self.average_label = None
        self.glyph_hidden = []
        self.review_titles = []
        self.review_dates = []
        self.body_html = ""
        self._stack = []
        self._paragraph = None
        self._website = None
        self._title = None
        self._date = None
        self._value = None

    def handle_starttag(self, tag, attrs):
        attr = dict(attrs)
        classes = set((attr.get("class") or "").split())
        parent = self._stack[-1] if self._stack else {}
        frame = {
            "tag": tag,
            "hero": parent.get("hero", False) or "brand-hero" in classes,
            "meta": parent.get("meta", False) or "brand-meta" in classes,
            "body": parent.get("body", False) or "brand-body" in classes,
            "review": parent.get("review", False) or "review-item" in classes,
        }
        self._stack.append(frame)
        self.classes.update(classes & SECTION_CLASSES)
        if "brand-meta" in classes and parent.get("hero"):
            self.meta_inside_hero = True
        if tag == "h1" and "site-title" in classes:
            self.extends_base = True
        if tag == "p" and frame["hero"] and self._paragraph is None:
            self._paragraph = ""
        if tag == "a" and frame["meta"] and self.website is None:
            self.website = {
                "href": attr.get("href"),
                "rel": attr.get("rel"),
                "target": attr.get("target"),
                "text": "",
            }
            self._website = ""
        if tag == "h2" and frame["review"] and self._title is None:
            self._title = ""
        if tag == "time" and frame["review"] and self._date is None:
            self._date = ""
        if tag == "span" and "stars" in classes:
            self.aria_labels.append(attr.get("aria-label"))
        if tag == "span" and classes & {"star-full", "star-half", "star-empty"}:
            self.glyph_hidden.append(attr.get("aria-hidden"))
        if tag == "span" and "rating-value" in classes and self._value is None:
            self._value = ""
        if frame["body"]:
            self.body_html += _start_html(tag, attrs)

    def handle_endtag(self, tag):
        frame = self._stack[-1] if self._stack else {}
        if frame.get("body"):
            self.body_html += f"</{tag}>"
        if tag == "p" and self._paragraph is not None:
            self.hero_paragraphs.append(" ".join(self._paragraph.split()))
            self._paragraph = None
        if tag == "a" and self._website is not None:
            self.website["text"] = " ".join(self._website.split())
            self._website = None
        if tag == "h2" and self._title is not None:
            self.review_titles.append(" ".join(self._title.split()))
            self._title = None
        if tag == "time" and self._date is not None:
            self.review_dates.append(" ".join(self._date.split()))
            self._date = None
        if tag == "span" and self._value is not None and frame.get("tag") == "span":
            self.average_label = " ".join(self._value.split())
            self._value = None
        if self._stack:
            self._stack.pop()

    def handle_data(self, data):
        frame = self._stack[-1] if self._stack else {}
        if self._paragraph is not None:
            self._paragraph += data
        if frame.get("meta"):
            self.meta_text += data
        if self._website is not None:
            self._website += data
        if self._title is not None:
            self._title += data
        if self._date is not None:
            self._date += data
        if self._value is not None:
            self._value += data
        if frame.get("body"):
            self.body_html += data

    def close(self):
        super().close()
        self.meta_text = " ".join(self.meta_text.split())
        self.body_html = self.body_html.strip()
        while self.body_html.startswith("<div") or self.body_html.startswith("<section"):
            end = "</section>" if self.body_html.startswith("<section") else "</div>"
            inner = self.body_html[self.body_html.find(">") + 1 :]
            if not inner.endswith(end):
                break
            self.body_html = inner[: -len(end)].strip()


def _page(html):
    page = _BrandPage()
    page.feed(html)
    page.close()
    return page


def _start_html(tag, attrs):
    parts = [tag]
    for key, value in attrs:
        parts.append(f'{key}="{value}"')
    return "<" + " ".join(parts) + ">"


def make_brand(**overrides):
    from content.models import Brand

    fields = {
        "wp_id": 1,
        "slug": "counted-brand",
        "title": "Counted",
        "is_published": True,
        "website_url": "https://counted.example.com/path",
        "founded_year": 2001,
        "headquarters": "Austin, TX",
        "average_rating": Decimal("4.00"),
    }
    fields.update(overrides)
    return Brand.objects.create(**fields)
