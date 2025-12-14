#!/bin/sh
set -e

# Eliminar el PID del servidor si existe (evita errores si el contenedor se reinicia mal)
rm -f /app/tmp/pids/server.pid

# Esperar a que la base de datos esté lista (opcional, ya que depends_on ayuda, pero es buena práctica)
# echo "Waiting for database..."
# sleep 5

# Ejecutar preparación de base de datos (crea, carga esquema o migra según sea necesario)
# db:prepare es más robusto para instalaciones nuevas ya que usa schema:load en lugar de correr todas las migraciones históricas
echo "Running database preparation..."
bundle exec rails db:prepare

# Iniciar el servidor
echo "Starting Rails server..."
exec bundle exec rails s -p 3000 -b 0.0.0.0
