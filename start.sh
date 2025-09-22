#!/bin/bash

echo "🚀 Starting Directus initialization process..."
echo "🔗 Connecting to database..."

# Verificar conexión a la base de datos
echo "📊 Database client: $DB_CLIENT"
echo "🏠 Database host: $DB_HOST"
echo "📱 Database port: $DB_PORT"
echo "🗄️  Database name: $DB_DATABASE"

# Ejecutar bootstrap para instalar tablas de Directus
echo "⚡ Running Directus bootstrap..."
npx directus bootstrap

# Verificar si bootstrap fue exitoso
if [ $? -eq 0 ]; then
    echo "✅ Bootstrap completed successfully!"
    echo "🚀 Starting Directus server..."
    npx directus start
else
    echo "❌ Bootstrap failed. Trying to start anyway..."
    npx directus start
fi