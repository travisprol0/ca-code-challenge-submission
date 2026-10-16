# WordPress → Django Migration Challenge

Welcome. This is a take-home exercise plus a short live walkthrough. We are hiring senior full-stack engineers, and we expect you to use AI tooling (Claude, Cursor, Copilot, whatever you prefer) the same way you would on the job. The point of this challenge is **not** to see whether AI can produce working code — it can. The point is to see how you direct it, what decisions you take ownership of, and how you defend them.

## How the evaluation works

1. **Take-home (offline):** complete the challenge below at your own pace. Most of the code should be done before the call.
2. **Live session (~1 hour):** you walk us through what you built, we probe a handful of decisions, and we hand you a new requirement to design through together. You will be using your AI tooling during the live session — we want to see you work.

We are explicitly evaluating:
- Architectural judgment (schema, API contracts, service boundaries, shared code, component boundaries, SCSS structure).
- How you brief and steer the AI (context, prompts, when you accept output, when you push back).
- How well you understand and can defend the code you submit.
- Frontend craft (React component design, CSS architecture, accessibility, responsive behavior).

If your AI tooling generated something you cannot explain or defend, that is the signal we are looking for — and we will find it. Use AI freely; own the result.

## Setup

You need Docker. Nothing else.

```bash
cp .env.example .env
docker compose up -d
```

Wait ~20 seconds for the database to import. Then:

- Public WP site: <http://localhost:8080>
- WP admin: <http://localhost:8080/wp-admin>  (`admin` / `admin`)
- phpMyAdmin: <http://localhost:8081>  (`wp` / `wp`)
- REST API: <http://localhost:8080/wp-json/wp/v2/>

Everything is committed; you should not need to install anything inside the WP container.

## What you're building

A Django app that replaces the WordPress site, plus a small React component, an SCSS source tree, a separate Django service for authentication and authorization, and a Python library holding the code both services share.

### Pillar 1 — Django backend

Reproduce the WP site as a Django app:

- **Models** that mirror the domain: brands, reviews, industries, reviewer users. Don't blindly copy WP's denormalized `wp_posts` + `wp_postmeta` shape — design a clean relational model for this domain.
- **A data migration step** that pulls the WP content into your Django DB. Approach is your call: parse `db/dump.sql`, hit the REST API, query MariaDB directly, write a `manage.py` command. Whatever you pick, it must be **re-runnable** without producing duplicates.
- **Server-rendered pages** at minimum for: homepage (hero + recent reviews), brand detail at `/brand/<slug>/`, and review detail at `/review/<slug>/`. URL slugs must match WP's permalinks.

### Pillar 2 — REST API for the brand listing

Expose a single endpoint that serves the brand listing data:

- `GET /api/brands/`
- Filterable by industry.
- Sortable by average rating and by review count.
- Paginated.
- Returns enough data per row to render a card: name, slug, industry, average rating, review count, short description, and the "top review snippet" for that brand (you decide what "top" means and document it).

Stack choice (DRF, Django Ninja, plain views returning JSON) is yours.

### Pillar 3 — React `<BrandList />` component

A single component, but built like it would ship to production:

- Consumes the endpoint from Pillar 2.
- Industry filter (single or multi-select, your call).
- Sort control.
- Loading, empty, and error states all handled.
- Keyboard accessible; semantic markup; meets basic a11y expectations.
- Responsive across mobile and desktop.

No specific UI framework is mandated. Vanilla CSS, CSS modules, Tailwind, styled-components — you choose, and be ready to defend it.

### Pillar 4 — SCSS source files

In [reference/theme.css](reference/theme.css) you will find the compiled CSS from the WordPress theme. Your job is to **produce the SCSS source files** that compile to equivalent CSS, organized however a senior engineer would organize them.

We are not grading byte-for-byte equivalence. We are grading the **structure**: design tokens, partials, naming conventions, separation of concerns, how easy it would be for another engineer to extend.

Place your SCSS under `frontend/scss/` (or whatever location makes sense in your project layout). Include a brief note in your README on how to compile it.

### Pillar 5 — Auth service (separate Django project)

Authentication and authorization live in their own Django service, deployed as its own container with its own database. The main app does not store passwords or roles.

- **Users** are owned by the auth service. The `wp_users` accounts must exist there after migration (passwords may be reset; you decide how).
- **Login**: an endpoint that exchanges credentials for a token. Token format (JWT, opaque + introspection, session) is your call.
- **Authorization**: at least two roles, e.g. `reader` and `editor`. The auth service is the source of truth for which user has which role/permission.
- **Protected endpoint in the main app**: add one write endpoint, e.g. `PATCH /api/brands/<slug>/` to edit a brand's short description, that only `editor` can call. `GET /api/brands/` and the server-rendered pages stay public.
- Decide whether the main app verifies tokens locally or calls the auth service on every request, and document why.

### Pillar 6 — Shared Python library

Code used by both Django services goes into a separate, installable Python package rather than being copied between them.

- Its own `pyproject.toml`, versioned, installed into both services (local path, git URL, or private index; your call).
- At minimum it holds the token verification and permission-check code the main app uses to protect its endpoint (e.g. a DRF authentication class and permission class, or a decorator for plain views).
- Has its own tests that run without either Django project.
- Keep it small. Only code that both services actually use belongs there; be ready to justify each module.

## Decisions you will defend live

Come prepared to answer these on the call. There is no single right answer to any of them.

1. **Schema modeling.** A brand has an `average_rating` ACF field AND has reviews with individual ratings. Do you store the average, derive it, or both? Why? How do you handle reviewer users — full Django users, a separate Reviewer model, or denormalized strings on each review?
2. **Postmeta strategy.** `wp_postmeta` has ~30 fields per brand (including Yoast SEO). Which became first-class model fields, which became JSON, which did you drop?
3. **Migration approach.** Why this approach? How do you re-run it safely? How would you scale it to 100x the data?
4. **API contract.** Why this pagination shape? Why these filter/sort param names? What would change if a mobile client also consumed it?
5. **Component & state.** Where does `<BrandList />` state live? How do you handle URL-synced filter/sort state? What's your loading/error UX?
6. **SCSS architecture.** Why these partials? Why these tokens? How would a second engineer add a new component without breaking yours?
7. **Service boundary.** What does the auth service own and what does the main app own? How does the main app validate a token, and what happens when the auth service is down? How do you revoke a token or change a user's role before the token expires?
8. **Shared library.** What went into it and what did you keep out? How do the two services pin and upgrade it? How would you release a breaking change without deploying both services at the same moment?

## What's explicitly out of scope

- Migrating the WP admin / editor experience.
- Yoast SEO frontend output (the data is in the DB if you want to surface it).
- WP plugin parity beyond data structure.
- User-facing review submission, search.
- Registration, password reset, social login, MFA. Login plus role-based access is enough.
- A login UI. Obtaining a token via `curl` or the DRF browsable API is fine.
- Image uploads (placeholder boxes are fine; no real logos are seeded).
- Pixel-matching the WP theme. Equivalent CSS *structure*, not identical output.

## Where the data lives

| What | Where |
|---|---|
| Brands | WP custom post type `brand`, table `wp_posts` where `post_type = 'brand'` |
| Reviews | WP custom post type `review`, table `wp_posts` where `post_type = 'review'` |
| ACF custom fields | `wp_postmeta` (e.g. `website_url`, `founded_year`, `rating`, `brand`) |
| Industry taxonomy | `wp_terms`, `wp_term_taxonomy`, `wp_term_relationships` |
| Users | `wp_users` |
| Yoast SEO data | `wp_postmeta` keys starting with `_yoast_wpseo_` |

The custom post types and ACF fields are defined in code at:
- [wp-content/mu-plugins/cpt.php](wp-content/mu-plugins/cpt.php)
- [wp-content/mu-plugins/acf-fields.php](wp-content/mu-plugins/acf-fields.php)

Read these for the authoritative schema.

## REST endpoints (WordPress side, for migration source)

- `GET /wp-json/wp/v2/brands?per_page=100` — all brands (ACF fields under `acf` key)
- `GET /wp-json/wp/v2/reviews?per_page=100` — all reviews
- `GET /wp-json/wp/v2/industry` — taxonomy terms
- `GET /wp-json/wp/v2/users` — users

## What to deliver

A single repository (or a fork of this one) containing:

- The Django project.
- The migration command/script.
- The React `<BrandList />` component.
- The SCSS source tree under `frontend/scss/`.
- The auth service as a separate Django project, wired into `docker-compose.yml`.
- The shared Python library as a separate package (its own directory or repository) with its tests.
- A `README.md` with:
  - How to run the Django app, the auth service, and the React component locally.
  - How to get a token and call the protected endpoint.
  - How to run the shared library's tests and how a new version reaches each service.
  - How to run the migration (and how to re-run it safely).
  - A short section — half a page is plenty — on the modeling decisions you made, what you would do differently with more time, and any places you deliberately chose AI's default over your own preference (and why).

## The live session (~1 hour)

You will:

1. Walk us through what you built (~10 min).
2. Answer probes on the decisions listed above (~20 min).
3. Work through a new requirement we hand you on the call (~25-30 min). You will use your AI tooling. We are watching how you brief it, how you read its output, and what you push back on.

Good luck. If you hit infrastructure problems, reach out — we want you spending your time on the interesting parts.
