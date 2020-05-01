#!/bin/sh
set -e

if [ "$1" = "nginx" ]; then
  export FPM_SERVICE=${FPM_SERVICE:-fpm}
  envsubst '\$FPM_SERVICE' < /etc/nginx/conf.d/default.conf.stuff > /etc/nginx/conf.d/default.conf
fi

exec "$@"