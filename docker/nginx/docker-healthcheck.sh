#!/bin/sh
set -e

if [ $(curl -sS 'http://localhost/healthcheck') = 'healthy' ]; then
  exit 0
fi

exit 1