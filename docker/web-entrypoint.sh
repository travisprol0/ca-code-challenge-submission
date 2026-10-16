#!/bin/sh
set -eu
while [ ! -s /shared/public.pem ]; do
  sleep 0.5
done
python manage.py migrate --noinput
exec python manage.py runserver 0.0.0.0:8000 --noreload
