SHELL := /bin/bash
COMPOSE := docker compose
WPCLI := $(COMPOSE) run --rm wpcli

.PHONY: help up down restart logs reset wp bootstrap dump status test test-auth test-app lint release-shared test-scss css

help:
	@echo "Targets:"
	@echo "  up              Start db, wordpress, phpmyadmin, postgres, web, and auth"
	@echo "  down            Stop containers (preserve data)"
	@echo "  reset           Stop containers AND wipe DB volume (full cold start on next 'up')"
	@echo "  logs            Tail wordpress + db logs"
	@echo "  wp ARGS=\"...\" Run wp-cli inside the stack (e.g. make wp ARGS=\"plugin list\")"
	@echo "  bootstrap       One-shot: install WP core + plugins + seed all content"
	@echo "  dump            Export current DB to db/dump.sql"
	@echo "  status          Show running services"
	@echo "  test            Run the shared-library suite inside a container"
	@echo "  test-auth       Run the auth user suite inside a container"
	@echo "  test-app        Run the main-app suite inside a container"
	@echo "  lint            Run lint inside containers"
	@echo "  release-shared  Build the shared-auth wheel into packages/wheelhouse"
	@echo "  css             Compile frontend/scss/main.scss to app/static/dist/main.css"
	@echo "  test-scss       Compile SCSS with sass and check the result"

up:
	$(COMPOSE) up -d db wordpress phpmyadmin postgres web auth

down:
	$(COMPOSE) down

reset:
	$(COMPOSE) down -v
	@echo "Volume wiped. Run 'make up' to start fresh from db/dump.sql"

logs:
	$(COMPOSE) logs -f wordpress db

wp:
	$(WPCLI) $(ARGS)

bootstrap:
	$(COMPOSE) run --rm --entrypoint bash wpcli /scripts/seed.sh

dump:
	@mkdir -p db
	$(COMPOSE) exec db sh -c 'mariadb-dump -u root -p"$$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 --add-drop-table --skip-extended-insert "$$MYSQL_DATABASE"' > db/dump.sql
	@echo "Wrote db/dump.sql ($$(wc -l < db/dump.sql) lines)"

status:
	$(COMPOSE) ps

test:
	@test -d packages/shared-auth || { echo "packages/shared-auth is not present"; exit 1; }
	$(COMPOSE) --profile test run --rm --build shared-test

test-auth:
	$(COMPOSE) up -d db postgres
	$(COMPOSE) run --rm --build --entrypoint pytest auth

test-app:
	$(COMPOSE) up -d db postgres
	$(COMPOSE) run --rm --build --no-deps --entrypoint pytest web

release-shared:
	mkdir -p packages/wheelhouse
	$(COMPOSE) --profile test run --rm --build \
		--entrypoint bash \
		-v "$(CURDIR)/packages/wheelhouse:/wheelhouse" \
		shared-test \
		-c "pip install --no-cache-dir build && cp -a /src /tmp/shared-auth && python -m build --wheel --outdir /wheelhouse /tmp/shared-auth"

lint:
	$(COMPOSE) run --rm --build --no-deps --entrypoint python web -m compileall -q /srv
	$(COMPOSE) run --rm --build --no-deps --entrypoint python auth -m compileall -q /srv

css:
	$(COMPOSE) --profile scss run --rm --entrypoint bash scss -lc "npm install --no-audit --no-fund && npm run build"

test-scss:
	$(COMPOSE) --profile scss run --rm --entrypoint bash scss -lc "npm install --no-audit --no-fund && npm test"
