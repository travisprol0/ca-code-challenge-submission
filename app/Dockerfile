FROM python:3.12-slim-bookworm
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 DJANGO_SETTINGS_MODULE=config.settings
WORKDIR /srv
RUN apt-get update \
    && apt-get install -y --no-install-recommends mariadb-client \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /tmp/requirements.txt
COPY packages/wheelhouse /tmp/wheelhouse
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && pip install --no-cache-dir --find-links /tmp/wheelhouse "shared-auth[drf]==1.0.1"
COPY app/ /srv/
COPY docker/web-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
