#!/bin/sh
set -e

if [ "$1" = 'fpm' ] || [ "$1" = 'supervisor' ] || [ "$1" = 'setup' ]; then
  mkdir -p \
        /laravel/storage/app/public \
        /laravel/storage/framework/cache \
        /laravel/storage/framework/sessions \
        /laravel/storage/framework/views \
        /laravel/storage/logs;
  setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX /laravel/storage
  setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX /laravel/storage

  ./artisan storage:link

  if [ ${APP_ENV:-local} = 'production' ]; then
    	./artisan config:cache;
  fi

	if [ "$1" = 'supervisor' ]; then
	  cp /var/supervisord/base.conf /var/supervisord/supervisord.conf

    { \
      echo '[inet_http_server]'; \
      echo 'port = *:9000'; \
      echo "username = ${SUPERVISOR_USERNAME:-root}"; \
      echo "password = ${SUPERVISOR_PASSWORD:-root}"; \
    } >> /var/supervisord/supervisord.conf

    set -- supervisord -c /var/supervisord/supervisord.conf

    setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX /var/supervisord
    setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX /var/supervisord
  elif [ "$1" = 'fpm' ]; then
    set -- php-fpm
  elif [ "$1" = 'setup' ]; then
    # Install composer package & run migrate on dev env.

    composer install --prefer-dist --no-progress --no-suggest --no-interaction

    echo "Waiting for db to be ready..."

    until echo "app('db')->select('SELECT 1');" | ./artisan tinker > /dev/null 2>&1; do
      sleep 1
    done

    if ls -A database/migrations/*.php > /dev/null 2>&1; then
      ./artisan migrate --force
    fi

    exit 0
	fi

fi

exec docker-php-entrypoint "$@"