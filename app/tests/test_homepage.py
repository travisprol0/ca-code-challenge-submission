from html.parser import HTMLParser

import pytest
from django.core.management import call_command
from django.test import Client

pytestmark = pytest.mark.django_db(databases=["default"])

HERO = "Honest reviews of consumer brands"
HERO_PARAGRAPH = (
    "Independent customer feedback on insurance, telecom, finance, "
    "home services, and retail companies."
)
HOME_PAGE_BODY = "Welcome to our independent brand reviews directory."


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


def test_homepage_site_title_stays_and_hero_is_a_second_h1():
    call_command("import_wp")
    response = Client().get("/")
    assert response.status_code == 200
    page = _page(response)

    assert [heading["text"] for heading in page.h1s] == [
        "Brand Reviews Challenge",
        HERO,
    ]
    site_title, hero = page.h1s
    assert site_title["class"] == "site-title"
    assert site_title["in_main"] is False
    assert hero["in_main"] is True
    assert hero["text"] != site_title["text"]
    assert hero["class"] != "site-title"


def test_homepage_hero_copy_does_not_render_the_home_page_body():
    call_command("import_wp")
    response = Client().get("/")
    assert response.status_code == 200
    page = _page(response)
    raw = response.content.decode()

    assert page.h1s[1]["text"] == HERO
    assert any(paragraph["text"] == HERO_PARAGRAPH for paragraph in page.paragraphs)
    assert HOME_PAGE_BODY not in raw
    assert HERO in raw
    assert raw.strip() != HOME_PAGE_BODY


def test_homepage_mounts_the_brand_list_and_has_no_card_grid():
    call_command("import_wp")
    response = Client().get("/")
    raw = response.content.decode()
    page = _page(response)

    assert page.h1s[1]["text"] == HERO
    assert page.brand_list == 1
    assert page.grids == 0
    assert "brand-list-industries" in page.script_ids
    assert 'src="/static/dist/brand-list.js"' in raw or "dist/brand-list.js" in raw
    assert "recent-reviews" not in raw


class _HomePage(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self._stack = []
        self.h1s = []
        self.paragraphs = []
        self.brand_list = 0
        self.grids = 0
        self.script_ids = set()
        self._h1 = None
        self._p = None

    def handle_starttag(self, tag, attrs):
        attr = dict(attrs)
        classes = (attr.get("class") or "").split()
        self._stack.append(tag)
        if "grid" in classes:
            self.grids += 1
        if tag == "div" and attr.get("id") == "brand-list":
            self.brand_list += 1
        if tag == "script" and attr.get("id"):
            self.script_ids.add(attr["id"])
        if tag == "h1":
            self._h1 = {
                "class": attr.get("class"),
                "text": "",
                "in_main": "main" in self._stack[:-1],
            }
        elif tag == "p":
            self._p = {"class": attr.get("class"), "text": ""}

    def handle_endtag(self, tag):
        if tag == "h1" and self._h1 is not None:
            self._h1["text"] = " ".join(self._h1["text"].split())
            self.h1s.append(self._h1)
            self._h1 = None
        elif tag == "p" and self._p is not None:
            self._p["text"] = " ".join(self._p["text"].split())
            self.paragraphs.append(self._p)
            self._p = None
        self._stack.pop()

    def handle_data(self, data):
        if self._h1 is not None:
            self._h1["text"] += data
        if self._p is not None:
            self._p["text"] += data


def _page(response):
    assert response.status_code == 200
    page = _HomePage()
    page.feed(response.content.decode())
    return page
