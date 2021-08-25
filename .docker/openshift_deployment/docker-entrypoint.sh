#!/usr/bin/env sh
set -eu

envsubst '${MOD_SECURITY}' < /usr/local/nginx/conf.d/default-site.conf.template > /usr/local/nginx/conf.d/default-site.conf

exec "$@"