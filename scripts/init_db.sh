#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
  echo "psql is not installed"
  exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
  echo "sqlx is not installed"
  exit 1
fi

DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD=${POSTGRES_PASSWORD:=password}
DB_NAME=${POSTGRES_DB:=newsletter}
DB_PORT=${POSTGRES_PORT:=5432}

if [ -z "${SKIP_DOCKER}" ];
then
docker run \
    -e POSTGRES_USER=${DB_USER} \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    -e POSTGRES_DB=${DB_NAME} \
    -p ${DB_PORT}:5432 \
    -d postgres:13.2 \
    postgres -N 1000
fi

export PGPASSWORD=${DB_PASSWORD}



until psql -h "localhost" -p ${DB_PORT} -U ${DB_USER} -d "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

DATABASE_URL="postgresql://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}"

export DATABASE_URL
sqlx database create
sqlx migrate run
