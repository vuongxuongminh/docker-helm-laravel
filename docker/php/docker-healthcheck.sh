#!/bin/sh
set -e

if [ "$1" = 'fpm' ]; then
  export SCRIPT_NAME=/ping
  export SCRIPT_FILENAME=/ping
  export REQUEST_METHOD=GET

  if cgi-fcgi -bind -connect 127.0.0.1:9000; then
    exit 0
  fi
elif [ "$1" = 'supervisor' ]; then
  if curl -I http://localhost:9000; then
    exit 0
  fi
fi

exit 1
