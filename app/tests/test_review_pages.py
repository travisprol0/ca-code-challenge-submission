from datetime import datetime, timezone
from html.parser import HTMLParser
from uuid import uuid4

import pytest
from django.core.management import call_command
from django.test import Client

pytestmark = pytest.mark.django_db(databases=["default"])

DENIED_SLUG = "denied-a-clearly-covered-claim"
ARCHIVE_HERO = "All Reviews"
ARCHIVE_PARAGRAPH = "Honest customer feedback from real users."
PAGE_SIZE = 10


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


def test_denied_claim_review_page():
    from content.models import Review

    call_command("import_wp")
    review = Review.objects.get(slug=DENIED_SLUG)
    response = Client().get(f"/review/{DENIED_SLUG}/")
    assert response.status_code == 200
    raw = response.content.decode()
    page = _detail(raw)

    assert page.extends_base is True
    assert "review-hero" in page.classes
    assert "review-byline" in page.classes
    assert page.byline == "David L., Hartford, CT"
    assert 'class="container"' in raw
    assert page.full_stars == 1
    assert page.rating_value == "1.0"
    assert page.date == "May 19, 2026"
    assert page.posted_by == "Posted by David L."
    assert page.brand_link == {
        "href": "/brand/homeshield-pro/",
        "class": "brand-link",
        "text": "HomeShield Pro",
    }
    assert [item["kind"] for item in page.flow] == [
        "byline",
        "stars",
        "date",
        "posted",
        "brand",
    ]
    assert raw.strip() != review.brand.short_description
    assert review.brand.short_description not in {page.byline, page.posted_by, page.date}


def test_review_page_renders_title_and_body():
    from content.models import Review

    call_command("import_wp")
    review = Review.objects.get(slug=DENIED_SLUG)
    raw = Client().get(f"/review/{DENIED_SLUG}/").content.decode()
    headings = [text for text, classes in _h1s(raw) if "site-title" not in classes]

    assert review.title in headings
    assert "Garbage disposal stopped working." in raw
    assert review.body in raw


def test_about_renders_page_body():
    from content.models import Page

    call_command("import_wp")
    about = Page.objects.get(slug="about")
    first = Client().get("/about/")
    assert first.status_code == 200
    assert about.body in first.content.decode()

    marker = "<p>About marker <em>changed</em></p>"
    about.body = marker
    about.save(update_fields=["body"])
    second = Client().get("/about/")
    assert second.status_code == 200
    changed = second.content.decode()
    assert marker in changed
    assert marker not in first.content.decode()

    about.is_published = False
    about.save(update_fields=["is_published"])
    missing = Client().get("/about/")
    assert missing.status_code == 404
    assert marker not in missing.content.decode()


def test_review_archive_hero_and_page_size():
    from content.models import Review

    call_command("import_wp")
    response = Client().get("/review/")
    assert response.status_code == 200
    raw = response.content.decode()
    page = _archive(raw)

    assert page.extends_base is True
    assert page.h1s == ["Brand Reviews Challenge", ARCHIVE_HERO]
    assert page.hero_paragraph == ARCHIVE_PARAGRAPH
    assert "archive-hero" in page.classes
    assert "brand-label" in page.classes
    assert len(page.reviews) == PAGE_SIZE
    assert [review["date"] for review in page.reviews] == ["May 19, 2026"] * PAGE_SIZE
    expected = [
        (title, brand)
        for title, brand in Review.objects.order_by("-published_at", "wp_id").values_list(
            "title", "brand__title"
        )[:PAGE_SIZE]
    ]
    assert [(review["title"], review["brand"]) for review in page.reviews] == expected
    assert raw.strip() != expected[0][0]

    second = _archive(Client().get("/review/page/2/").content.decode())
    assert len(second.reviews) == PAGE_SIZE
    assert {review["title"] for review in page.reviews}.isdisjoint(
        {review["title"] for review in second.reviews}
    )

    brand = Review.objects.get(slug=DENIED_SLUG).brand
    long_words = ["Alpha", "&"] + [f"w{index}" for index in range(39)]
    long_review = make_review(
        brand,
        wp_id=91001,
        slug="queried-long-review",
        title="Queried Long Review",
        body="<script>alert(1)</script><p>" + " ".join(long_words) + "</p>",
        published_at=datetime(2031, 9, 3, tzinfo=timezone.utc),
    )
    make_review(
        brand,
        wp_id=91002,
        slug="queried-short-review",
        title="Queried Short Review",
        body="<p>kept <b>whole</b> sentence</p>",
        published_at=datetime(2031, 9, 2, tzinfo=timezone.utc),
    )
    response = Client().get("/review/")
    raw = response.content.decode()
    page = _archive(raw)
    by_title = {review["title"]: review for review in page.reviews}

    assert len(page.reviews) == PAGE_SIZE
    expected = [
        (title, brand_title)
        for title, brand_title in Review.objects.order_by("-published_at", "wp_id").values_list(
            "title", "brand__title"
        )[:PAGE_SIZE]
    ]
    assert [(review["title"], review["brand"]) for review in page.reviews] == expected
    assert [review["title"] for review in page.reviews[:2]] == [
        "Queried Long Review",
        "Queried Short Review",
    ]
    long_card = by_title["Queried Long Review"]
    short_card = by_title["Queried Short Review"]
    excerpt = " ".join(long_words[:40]) + "…"
    assert long_card["excerpt"] == excerpt
    assert long_card["excerpt"] != long_review.brand.short_description
    assert excerpt not in raw
    assert " ".join(["Alpha", "&amp;"] + [f"w{index}" for index in range(38)]) + "…" in raw
    assert "alert(1)" not in raw
    assert short_card["excerpt"] == "kept whole sentence"
    assert "hellip" not in short_card["excerpt"]
    assert long_card["date"] == "September 3, 2031"
    assert "Sep 3, 2031" not in raw
    assert short_card["date"] == "September 2, 2031"
    assert long_card["brand"] == brand.title
    assert "brand-label" in long_card["classes"]


def test_published_review_of_unpublished_brand_404s():
    from content.models import Brand, Reviewer

    brand = Brand.all_objects.create(
        wp_id=92001,
        slug="hidden-brand",
        title="Hidden Brand",
        is_published=False,
    )
    reviewer = Reviewer.objects.create(wp_id=92001, public_id=uuid4(), display_name="Hidden R.")
    make_review(
        brand,
        reviewer=reviewer,
        wp_id=92001,
        slug="hidden-brand-review",
        title="Secret Review Title",
        published_at=datetime(2032, 1, 1, tzinfo=timezone.utc),
    )

    detail = Client().get("/review/hidden-brand-review/")
    assert detail.status_code == 404
    assert "Secret Review Title" not in detail.content.decode()
    archive = Client().get("/review/")
    assert archive.status_code == 200
    assert "Secret Review Title" not in archive.content.decode()
    home = Client().get("/")
    assert home.status_code == 200
    assert "Secret Review Title" not in home.content.decode()


def test_no_page_shows_an_html_entity():
    call_command("import_wp")
    for url in ("/", "/review/", "/brand/acme-insurance/"):
        response = Client().get(url)
        assert response.status_code == 200
        raw = response.content.decode()
        assert "&amp;hellip;" not in raw, url
        assert "&hellip;" not in raw, url


def test_short_description_migration_rewrites_only_the_entity_suffix():
    import importlib

    from django.apps import apps

    from content.models import Brand

    migration = importlib.import_module("content.migrations.0004_short_description_ellipsis")
    rows = {
        "entity-suffix": "Long-running insurer founded in &hellip;",
        "already-rewritten": "Long-running insurer founded in…",
        "entity-mid-text": "Wait &hellip; then decide.",
        "no-space-entity": "Ends without a space&hellip;",
    }
    for index, (slug, text) in enumerate(rows.items(), start=93001):
        Brand.all_objects.create(
            wp_id=index,
            slug=slug,
            title=slug,
            short_description=text,
            is_published=True,
        )

    migration.rewrite_entity_suffix(apps, None)
    first = dict(Brand.all_objects.filter(slug__in=rows).values_list("slug", "short_description"))
    migration.rewrite_entity_suffix(apps, None)
    second = dict(Brand.all_objects.filter(slug__in=rows).values_list("slug", "short_description"))

    assert first == {
        "entity-suffix": "Long-running insurer founded in…",
        "already-rewritten": "Long-running insurer founded in…",
        "entity-mid-text": "Wait &hellip; then decide.",
        "no-space-entity": "Ends without a space&hellip;",
    }
    assert second == first


def test_review_archive_links_stars_and_byline():
    from content.models import Review

    call_command("import_wp")
    brand = Review.objects.get(slug=DENIED_SLUG).brand
    located = make_review(
        brand,
        wp_id=94001,
        slug="archive-located",
        title="Archive Located",
        rating=2,
        reviewer_location="Hartford, CT",
        published_at=datetime(2033, 3, 4, tzinfo=timezone.utc),
    )
    make_review(
        brand,
        wp_id=94002,
        slug="archive-no-location",
        title="Archive No Location",
        rating=4,
        reviewer_location="",
        published_at=datetime(2033, 3, 3, tzinfo=timezone.utc),
    )

    items = _archive_items(Client().get("/review/").content.decode())
    first, second = items.articles[0], items.articles[1]

    assert "review-item" in first["classes"]
    assert first["links"] == [
        (f"/brand/{brand.slug}/", brand.title),
        ("/review/archive-located/", "Archive Located"),
    ]
    assert first["full_stars"] == 2
    assert first["empty_stars"] == 3
    assert first["rating_value"] is False
    assert first["byline"] == f"{located.reviewer.display_name}, Hartford, CT · March 4, 2033"
    assert first["datetime"] == "2033-03-04"

    assert second["links"][1] == ("/review/archive-no-location/", "Archive No Location")
    assert second["full_stars"] == 4
    assert second["byline"] == f"{located.reviewer.display_name} · March 3, 2033"


def test_review_archive_pages_at_wordpress_urls():
    from content.models import Review

    call_command("import_wp")
    total = Review.objects.count()
    assert total > PAGE_SIZE
    last = -(-total // PAGE_SIZE)

    first = _archive(Client().get("/review/").content.decode())
    second_response = Client().get("/review/page/2/")
    assert second_response.status_code == 200
    second = _archive(second_response.content.decode())
    assert second.reviews
    assert {review["title"] for review in first.reviews}.isdisjoint(
        {review["title"] for review in second.reviews}
    )

    ignored = _archive(Client().get("/review/?page=2").content.decode())
    assert [review["title"] for review in ignored.reviews] == [
        review["title"] for review in first.reviews
    ]

    redirect = Client().get("/review/page/1/")
    assert redirect.status_code == 301
    assert redirect["Location"] == "/review/"

    assert Client().get(f"/review/page/{last}/").status_code == 200
    assert Client().get(f"/review/page/{last + 1}/").status_code == 404
    assert Client().get("/review/page/0/").status_code == 404


def test_review_archive_pager():
    from content.models import Review

    call_command("import_wp")
    total = Review.objects.count()
    last = -(-total // PAGE_SIZE)
    assert last >= 2

    one = _archive_items(Client().get("/review/").content.decode()).pager
    assert one["present"] is True
    assert one["classes"] >= {"pagination"}
    assert one["current"] == "1"
    assert ("/review/page/2/", "2") in one["links"]
    assert ("/review/page/2/", "Next") in one["links"]
    assert not any(text == "Previous" for _, text in one["links"])
    numbers = [text for _, text in one["links"] if text.isdigit()]
    assert sorted([*numbers, one["current"]], key=int) == [str(n) for n in range(1, last + 1)]

    two = _archive_items(Client().get("/review/page/2/").content.decode()).pager
    assert two["current"] == "2"
    assert ("/review/", "1") in two["links"]
    assert ("/review/", "Previous") in two["links"]

    end = _archive_items(Client().get(f"/review/page/{last}/").content.decode()).pager
    assert end["current"] == str(last)
    assert not any(text == "Next" for _, text in end["links"])

    keep = list(
        Review.objects.order_by("-published_at", "wp_id").values_list("pk", flat=True)[:PAGE_SIZE]
    )
    Review.all_objects.exclude(pk__in=keep).delete()
    single = _archive_items(Client().get("/review/").content.decode())
    assert len(single.articles) == PAGE_SIZE
    assert single.pager["present"] is False


class _ArchiveItems(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.articles = []
        self.pager = {"present": False, "classes": set(), "current": None, "links": []}
        self._stack = []
        self._article = None
        self._link = None
        self._byline = None
        self._current = None
        self._in_nav = False

    def handle_starttag(self, tag, attrs):
        attr = dict(attrs)
        classes = set((attr.get("class") or "").split())
        self._stack.append({"tag": tag, "classes": classes})
        if tag == "article":
            self._article = {
                "classes": classes,
                "links": [],
                "full_stars": 0,
                "empty_stars": 0,
                "rating_value": False,
                "byline": "",
                "datetime": None,
            }
            self.articles.append(self._article)
        if tag == "nav" and attr.get("aria-label") == "Pagination":
            self._in_nav = True
            self.pager["present"] = True
            self.pager["classes"] = classes
        if tag == "a" and (self._article is not None or self._in_nav):
            self._link = {"href": attr.get("href"), "text": ""}
        if self._in_nav and attr.get("aria-current") == "page":
            self._current = ""
        if self._article is None:
            return
        if "star-full" in classes:
            self._article["full_stars"] += 1
        if "star-empty" in classes:
            self._article["empty_stars"] += 1
        if "rating-value" in classes:
            self._article["rating_value"] = True
        if "review-byline" in classes:
            self._byline = {"tag": tag, "depth": len(self._stack), "text": ""}
        if tag == "time":
            self._article["datetime"] = attr.get("datetime")

    def handle_endtag(self, tag):
        if tag == "a" and self._link is not None:
            pair = (self._link["href"], _squash(self._link["text"]))
            if self._in_nav:
                self.pager["links"].append(pair)
            else:
                self._article["links"].append(pair)
            self._link = None
        if self._current is not None and self._in_nav and tag != "a":
            self.pager["current"] = _squash(self._current)
            self._current = None
        if self._byline is not None and tag == self._byline["tag"] and len(self._stack) == self._byline["depth"]:
            self._article["byline"] = _squash(self._byline["text"])
            self._byline = None
        if tag == "article":
            self._article = None
        if tag == "nav":
            self._in_nav = False
        if self._stack:
            self._stack.pop()

    def handle_data(self, data):
        if self._link is not None:
            self._link["text"] += data
        if self._current is not None:
            self._current += data
        if self._byline is not None:
            self._byline["text"] += data


def _archive_items(html):
    page = _ArchiveItems()
    page.feed(html)
    page.close()
    return page


class _DetailPage(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.extends_base = False
        self.classes = set()
        self.byline = ""
        self.full_stars = 0
        self.rating_value = None
        self.date = ""
        self.posted_by = ""
        self.brand_link = None
        self.flow = []
        self._stack = []
        self._byline = None
        self._date = None
        self._posted = None
        self._brand = None
        self._value = None

    def handle_starttag(self, tag, attrs):
        attr = dict(attrs)
        classes = set((attr.get("class") or "").split())
        self.classes.update(classes & {"review-hero", "review-byline", "brand-link"})
        self._stack.append({"tag": tag, "classes": classes})
        if tag == "h1" and "site-title" in classes:
            self.extends_base = True
        if tag == "p" and "review-byline" in classes and self._byline is None:
            self._byline = ""
            self.flow.append({"kind": "byline"})
        if tag == "span" and "stars" in classes:
            self.flow.append({"kind": "stars"})
        if tag == "span" and "star-full" in classes:
            self.full_stars += 1
        if tag == "span" and "rating-value" in classes and self._value is None:
            self._value = ""
        if tag == "time" and self._date is None:
            self._date = ""
            self.flow.append({"kind": "date"})
        if (
            tag == "p"
            and any("review-hero" in frame["classes"] for frame in self._stack)
            and "review-byline" not in classes
            and self._posted is None
        ):
            self._posted = ""
            self.flow.append({"kind": "posted"})
        if tag == "a" and "brand-link" in classes and self._brand is None:
            self._brand = ""
            self.brand_link = {
                "href": attr.get("href"),
                "class": attr.get("class"),
                "text": "",
            }
            self.flow.append({"kind": "brand"})

    def handle_endtag(self, tag):
        frame = self._stack[-1] if self._stack else {}
        if tag == "p" and self._byline is not None and "review-byline" in frame.get("classes", set()):
            self.byline = _squash(self._byline)
            self._byline = None
        if tag == "span" and self._value is not None and "rating-value" in frame.get("classes", set()):
            self.rating_value = _squash(self._value)
            self._value = None
        if tag == "time" and self._date is not None:
            self.date = _squash(self._date)
            self._date = None
        if tag == "p" and self._posted is not None and "review-byline" not in frame.get("classes", set()):
            self.posted_by = _squash(self._posted)
            self._posted = None
        if tag == "a" and self._brand is not None and "brand-link" in frame.get("classes", set()):
            self.brand_link["text"] = _squash(self._brand)
            self._brand = None
        if self._stack:
            self._stack.pop()

    def handle_data(self, data):
        if self._byline is not None:
            self._byline += data
        if self._value is not None:
            self._value += data
        if self._date is not None:
            self._date += data
        if self._posted is not None:
            self._posted += data
        if self._brand is not None:
            self._brand += data


class _ArchivePage(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.extends_base = False
        self.classes = set()
        self.h1s = []
        self.hero_paragraph = ""
        self.reviews = []
        self._stack = []
        self._h1 = None
        self._hero_p = None
        self._review = None
        self._text = None
        self._capture = None

    def handle_starttag(self, tag, attrs):
        attr = dict(attrs)
        classes = set((attr.get("class") or "").split())
        self.classes.update(classes & {"archive-hero", "brand-label"})
        parent = self._stack[-1] if self._stack else {}
        frame = {
            "tag": tag,
            "classes": classes,
            "hero": parent.get("hero", False) or "archive-hero" in classes,
            "review": parent.get("review", False) or tag == "article",
        }
        self._stack.append(frame)
        if tag == "h1" and "site-title" in classes:
            self.extends_base = True
        if tag == "h1":
            self._h1 = ""
        elif tag == "p" and frame["hero"] and "excerpt" not in classes and self._hero_p is None:
            self._hero_p = ""
        elif tag == "article":
            self._review = {
                "title": "",
                "brand": "",
                "date": "",
                "excerpt": "",
                "classes": set(),
            }
            self.reviews.append(self._review)
        elif self._review is not None and tag in {"h2", "time", "p"}:
            self._text = ""
            if "brand-label" in classes:
                self._capture = "brand"
                self._review["classes"].add("brand-label")
            elif tag == "h2":
                self._capture = "title"
            elif tag == "time":
                self._capture = "date"
            elif "excerpt" in classes:
                self._capture = "excerpt"
            else:
                self._capture = None
                self._text = None

    def handle_endtag(self, tag):
        frame = self._stack[-1] if self._stack else {}
        if tag == "h1" and self._h1 is not None:
            self.h1s.append(_squash(self._h1))
            self._h1 = None
        elif tag == "p" and self._hero_p is not None and frame.get("hero"):
            self.hero_paragraph = _squash(self._hero_p)
            self._hero_p = None
        elif tag == "article":
            self._review = None
        elif self._text is not None and tag in {"h2", "time", "p"} and self._capture:
            self._review[self._capture] = _squash(self._text)
            self._text = None
            self._capture = None
        if self._stack:
            self._stack.pop()

    def handle_data(self, data):
        if self._h1 is not None:
            self._h1 += data
        if self._hero_p is not None:
            self._hero_p += data
        if self._text is not None:
            self._text += data


class _H1s(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.headings = []
        self._text = None
        self._classes = ""

    def handle_starttag(self, tag, attrs):
        if tag == "h1":
            self._classes = dict(attrs).get("class") or ""
            self._text = ""

    def handle_endtag(self, tag):
        if tag == "h1" and self._text is not None:
            self.headings.append((_squash(self._text), self._classes))
            self._text = None

    def handle_data(self, data):
        if self._text is not None:
            self._text += data


def _h1s(html):
    page = _H1s()
    page.feed(html)
    page.close()
    return page.headings


def _detail(html):
    page = _DetailPage()
    page.feed(html)
    page.close()
    return page


def _archive(html):
    page = _ArchivePage()
    page.feed(html)
    page.close()
    return page


def _squash(text):
    return " ".join(text.split())


def make_review(brand, reviewer=None, **overrides):
    from content.models import Review, Reviewer

    if reviewer is None:
        reviewer = Reviewer.objects.get(display_name="David L.")
    fields = {
        "wp_id": 1,
        "slug": "extra-review",
        "title": "Extra review",
        "body": "Worked as expected.",
        "rating": 5,
        "reviewer": reviewer,
        "reviewer_location": "Hartford, CT",
        "published_at": datetime(2026, 5, 19, tzinfo=timezone.utc),
        "brand": brand,
        "is_published": True,
    }
    fields.update(overrides)
    return Review.all_objects.create(**fields)
