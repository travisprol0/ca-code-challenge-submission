from pathlib import Path

HEADINGS = (
    "## Run",
    "## Migration",
    "## Auth",
    "## React and SCSS",
    "## Shared library",
    "## Modeling",
    "## With more time",
    "## Where I kept the AI's default",
)

FACTS = (
    "http://localhost:8000",
    "http://localhost:8001",
    "/brand/",
    "import_wp_users",
    "import_wp",
    "short_description",
    "POST http://localhost:8001/api/token/",
    "PATCH http://localhost:8000/api/brands/acme-insurance/",
    "make test",
    "make release-shared",
    "shared-auth[drf]==",
    "make css",
    "frontend/scss/main.scss",
    "cached from published reviews",
    "closest to that average",
    "mounted public keys",
    "waiting until it expires",
)

ABSENT = (
    "## Notes for the maintainer",
    "Interview Challenge Source",
)


def _readme():
    app_dir = Path(__file__).resolve().parents[1]
    for path in (app_dir.parent / "README.md", app_dir / "README.md"):
        if path.is_file():
            return path.read_text()
    raise AssertionError("README.md")


def test_readme_sets_token_in_this_shell_and_rerunning_replaces_it():
    text = _readme()
    auth = text.split("## Auth", 1)[1].split("## ", 1)[0]
    assert "export TOKEN=$(" in auth
    assert "Bearer $TOKEN" in auth
    assert "this shell only" in auth
    assert "Run the export again" in auth


def test_readme_contains_the_claims():
    text = _readme()
    missing = [snippet for snippet in FACTS if snippet not in text]
    assert missing == []
    assert "re-run" in text
    users_at = text.index("import_wp_users")
    assert text.index("import_wp", users_at + len("import_wp_users")) > users_at

    positions = [text.index(heading) for heading in HEADINGS]
    assert positions == sorted(positions)

    present = [snippet for snippet in ABSENT if snippet in text]
    assert present == []
