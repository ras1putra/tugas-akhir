#!/bin/bash

until pg_isready -h localhost -U "$POSTGRES_USER"; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

echo "PostgreSQL is ready."

psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" -d "postgres" <<EOF
  CREATE DATABASE $POSTGRES_DB_WORKER WITH OWNER = $POSTGRES_USER;
EOF

echo "Worker database created."

psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" -d "postgres" <<EOF
  -- Grant privileges to the database
  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
  
  -- Grant privileges to the worker database
  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB_WORKER TO $POSTGRES_USER;
EOF

echo "Privileges granted."

exit 0