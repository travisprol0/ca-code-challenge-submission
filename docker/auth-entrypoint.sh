#!/bin/sh
set -eu
if [ ! -s /keys/private.pem ]; then
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out /keys/private.pem
  chmod 600 /keys/private.pem
fi
openssl rsa -in /keys/private.pem -pubout -out /shared/public.pem
python manage.py migrate --noinput
exec python manage.py runserver 0.0.0.0:8000 --noreload
