#!/bin/sh
set -e

mkdir -p /laravel/storage /laravel/bootstrap/cache

setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX /laravel/storage /laravel/bootstrap/cache
setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX /laravel/storage /laravel/bootstrap/cache

if [ "$1" = 'setup' ]; then
    umask 0000

    # First time we need to create project
    if [ ! -f composer.json ]; then
      composer create-project laravel/laravel tmp/ --prefer-dist --no-dev --no-progress --no-interaction;
      cp -Rp tmp/. .
      rm -Rf tmp/
    fi

    # Next time just ensure dependencies are up to date.

    composer install --prefer-dist --no-progress --no-interaction

    exit 0
fi

if [ "$1" = 'fpm' ]; then
  set -- php-fpm
fi

exec docker-php-entrypoint "$@"