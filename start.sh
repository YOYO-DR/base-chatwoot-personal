#!/bin/sh
set -e

# Eliminar el PID del servidor si existe (evita errores si el contenedor se reinicia mal)
rm -f /app/tmp/pids/server.pid

# Esperar a que la base de datos esté lista (opcional, ya que depends_on ayuda, pero es buena práctica)
# echo "Waiting for database..."
# sleep 5

# Ejecutar preparación de base de datos
# Verificamos si la base de datos ya tiene la tabla schema_migrations
# Si existe, corremos migraciones. Si no, cargamos el esquema (más seguro para instalaciones nuevas)

export PGHOST=$POSTGRES_HOST
export PGUSER=$POSTGRES_USERNAME
export PGPASSWORD=$POSTGRES_PASSWORD
export PGDATABASE=$POSTGRES_DATABASE

if psql -c "SELECT 1 FROM schema_migrations LIMIT 1;" > /dev/null 2>&1; then
  echo "Database already initialized. Running migrations..."
  bundle exec rails db:migrate
else
  echo "Database not initialized. Loading schema..."
  DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load
fi

# Iniciar el servidor
echo "Starting Rails server..."
exec bundle exec rails s -p 3000 -b 0.0.0.0
