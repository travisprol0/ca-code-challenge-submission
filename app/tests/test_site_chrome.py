import pytest
from django.test import Client
from html.parser import HTMLParser

pytestmark = pytest.mark.django_db(databases=["default"])


class _ArchivePage(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self._stack = []
        self.h1s = []
        self._h1 = None
        self.nav = None
        self._nav_link = None
        self.footer_text = []
        self._in_footer = False
        self.hero_text = []
        self._in_hero = False
        self.brand_list = False
        self._brand_list_open = False
        self.script_inside_brand_list = False
        self.stylesheets = []
        self.script_ids = []

    def handle_starttag(self, tag, attrs):
        attr = dict(attrs)
        self._stack.append(tag)
        if tag == "h1":
            self._h1 = {
                "class": attr.get("class"),
                "text": "",
                "hrefs": [],
                "in_main": "main" in self._stack[:-1],
            }
        elif tag == "a" and self._h1 is not None:
            self._h1["hrefs"].append(attr.get("href"))
        elif tag == "nav" and "site-nav" in (attr.get("class") or "").split():
            self.nav = {"label": attr.get("aria-label"), "links": []}
        elif (
            tag == "a"
            and self.nav is not None
            and self._h1 is None
            and "nav" in self._stack
        ):
            self._nav_link = {"href": attr.get("href"), "text": ""}
        elif tag == "footer":
            self._in_footer = True
        elif tag == "section" and "archive-hero" in (attr.get("class") or "").split():
            self._in_hero = True
        elif tag == "div" and attr.get("id") == "brand-list":
            self.brand_list = True
            self._brand_list_open = True
        elif tag == "script":
            if attr.get("id"):
                self.script_ids.append(attr.get("id"))
            if self._brand_list_open:
                self.script_inside_brand_list = True
        elif tag == "link" and attr.get("rel") == "stylesheet":
            self.stylesheets.append(attr.get("href"))

    def handle_endtag(self, tag):
        if tag == "h1" and self._h1 is not None:
            self._h1["text"] = " ".join(self._h1["text"].split())
            self.h1s.append(self._h1)
            self._h1 = None
        elif tag == "a" and self._nav_link is not None:
            self._nav_link["text"] = " ".join(self._nav_link["text"].split())
            self.nav["links"].append(self._nav_link)
            self._nav_link = None
        elif tag == "footer":
            self._in_footer = False
        elif tag == "section":
            self._in_hero = False
        elif tag == "div" and self._brand_list_open:
            self._brand_list_open = False
        if self._stack and self._stack[-1] == tag:
            self._stack.pop()

    def handle_data(self, data):
        if self._h1 is not None:
            self._h1["text"] += data
        if self._nav_link is not None:
            self._nav_link["text"] += data
        if self._in_footer:
            self.footer_text.append(data)
        if self._in_hero:
            self.hero_text.append(data)


def test_brand_archive_has_the_site_header_and_a_second_h1():
    response = Client().get("/brand/")
    assert response.status_code == 200
    page = _ArchivePage()
    page.feed(response.content.decode())

    assert [heading["text"] for heading in page.h1s] == [
        "Brand Reviews Challenge",
        "Brands",
    ]
    site_title, page_title = page.h1s
    assert site_title["class"] == "site-title"
    assert site_title["hrefs"] == ["/"]
    assert site_title["in_main"] is False
    assert page_title["in_main"] is True

    assert page.nav is not None
    assert page.nav["label"] == "Primary"
    assert page.nav["links"] == [
        {"href": "/", "text": "Home"},
        {"href": "/brand/", "text": "Brands"},
        {"href": "/review/", "text": "Reviews"},
        {"href": "/about/", "text": "About"},
    ]

    raw = response.content.decode()
    header = raw.split("<main", 1)[0]
    assert 'class="site-header"' in header
    assert 'class="container"' in header
    footer_html = raw.split("<footer", 1)[1]
    assert 'class="site-footer"' in raw
    assert 'class="container"' in footer_html

    footer = " ".join(page.footer_text)
    assert "Brand Reviews Challenge" in footer
    assert "Sample data for interview purposes." in footer

    hero = " ".join(page.hero_text)
    assert "Brands" in hero
    assert "Browse all brands in our reviews directory." in hero
    assert page.brand_list is True
    assert "brand-list-industries" in page.script_ids
    assert page.script_inside_brand_list is False
    assert any(href.endswith("dist/main.css") for href in page.stylesheets)
