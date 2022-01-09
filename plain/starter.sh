#!/bin/bash
set -e
cd /app
# Auto configuration
echo "Running pre-configuration..."
sh /autoconfig.sh

echo "Starting server..."
exec java \
    -jar /velocity/velocity.jar \
    --port="${PORT:-25565}" \
