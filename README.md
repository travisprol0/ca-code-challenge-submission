# Brand Reviews

The Django app serves the public site. The auth service issues access tokens. The React component is the brand list. The shared library is `shared_auth`.

## Run

```bash
cp .env.example .env
make up
```

`make up` starts the Django app, the auth service, Postgres, and WordPress. Open the Django site at <http://localhost:8000>. Auth is at <http://localhost:8001>. Homepage, `/brand/<slug>/`, and `/review/<slug>/` are server-rendered. The brand list is at <http://localhost:8000/brand/>.

WordPress stays at <http://localhost:8080> (`admin` / `admin`). `db/dump.sql` imports on first boot. It is the migration source.

## Migration

Run the auth users first, then the content.

```bash
docker compose run --rm --entrypoint python auth manage.py import_wp_users
docker compose run --rm --entrypoint python web manage.py import_wp
```

A re-run upserts on the WordPress id. It leaves `short_description` alone, including when an editor has cleared it, and it does not drop rows that are missing from the extract.

## Auth

Get an access token as `admin` / `admin` (an editor), then PATCH a brand's `short_description`. The body is that field only. The token response field is `access`. `TOKEN` is this shell only. Run the export again and it replaces the value. A new terminal starts without it, so run the export there too.

```bash
export TOKEN=$(curl -sS -X POST http://localhost:8001/api/token/ \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin"}' \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["access"])')

curl -sS -X PATCH http://localhost:8000/api/brands/acme-insurance/ \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"short_description":"Plain text from curl."}'
```

The main app verifies the JWT with the mounted public keys and does not call the auth service. With auth stopped, PATCH works until the access token expires. Login fails. Revoking a token means waiting until it expires.

## React and SCSS

`make css` compiles `frontend/scss/main.scss` to `app/static/dist/main.css` and writes `app/static/dist/brand-list.js`. The `web` container serves that file, and the component mounts on `/brand/`. `make test-scss` compiles the SCSS and checks the result.

## Shared library

`make test` runs the shared library's tests. `make release-shared` builds the wheel into `packages/wheelhouse/`. A release reaches each service when that pin is bumped: both Dockerfiles install `shared-auth[drf]==1.0.1` with `--find-links`.

## Modeling

`average_rating` and `review_count` are cached from published reviews. I dropped WordPress's stored average because it disagrees with the reviews. The top review is the published review closest to that average. A tie goes to the newer `published_at`, then the higher `wp_id`.

Reviewers are a model in the main app, with no passwords. Location stays on the review.

Website, founded year, headquarters, and the two Yoast strings are columns. Yoast is stored and not rendered. ACF bookkeeping keys are dropped. There is no JSON column.

`short_description` is written only when the brand row is created. A re-run and an editor PATCH leave it alone after that.

## With more time

Revoke an access token before the five minutes are up. Today, removing the editor role does not affect a token already issued. The emergency move is rotating the signing key.

## Where I kept the AI's default

A bare `&hellip;` stays. Only the importer's trailing ` &hellip;` becomes `…`.

`/review/?page=2` stays on page 1 because the archive address is `/review/page/<n>/`.

The archive pager lists every page number. WordPress would collapse the middle with many more pages.
