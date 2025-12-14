#!/bin/sh
set -e

# Eliminar el PID del servidor si existe (evita errores si el contenedor se reinicia mal)
rm -f /app/tmp/pids/server.pid

# Esperar a que la base de datos esté lista (opcional, ya que depends_on ayuda, pero es buena práctica)
# echo "Waiting for database..."
# sleep 5

# Ejecutar migraciones de base de datos
echo "Running database migrations..."
bundle exec rails db:migrate

# Iniciar el servidor
echo "Starting Rails server..."
exec bundle exec rails s -p 3000 -b 0.0.0.0
