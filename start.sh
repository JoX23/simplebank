#!/bin/sh

set -e

echo "run db migration"
pwd
ls -l
/app/migrate -path /app/db/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
