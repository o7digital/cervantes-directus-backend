#!/bin/sh

echo "🔧 Checking if Directus tables are installed..."

if [ -n "$RAILWAY_ENVIRONMENT" ]; then
  echo "⏳ Waiting for Railway private network..."
  sleep "${RAILWAY_PRIVATE_NETWORK_DELAY:-5}"
fi

# Try to bootstrap if tables don't exist
if ! npx directus schema list --depth 1 > /dev/null 2>&1; then
  echo "📦 Running Directus bootstrap..."
  npx directus bootstrap
fi

echo "🧩 Applying Directus database fixes..."
node scripts/apply-directus-fixes.mjs

echo "🚀 Starting Directus..."
exec npx directus start
