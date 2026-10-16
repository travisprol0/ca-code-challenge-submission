FROM python:3.12-slim-bookworm
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 DJANGO_SETTINGS_MODULE=config.settings
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /srv
COPY requirements.txt /tmp/requirements.txt
COPY packages/wheelhouse /tmp/wheelhouse
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && pip install --no-cache-dir --find-links /tmp/wheelhouse "shared-auth[drf]==1.0.1"
COPY auth/ /srv/
COPY docker/auth-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
