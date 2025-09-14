#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting deployment process..."

# 1. Install dependencies
echo "Running npm install..."
npm install

# 2. Build the application
echo "Building the application..."
npm run build

echo "Copying environment files..."
cp .env dist/smart-grocery-assistant/server/
cp io-connect-service-account.json dist/smart-grocery-assistant/server/

# 3. Deploy with pm2
echo "Stopping and deleting existing 'smart-grocery-assistant' pm2 process..."
pm2 stop smart-grocery-assistant || true # Continue even if stop fails (process might not exist)
pm2 delete smart-grocery-assistant || true # Continue even if delete fails

echo "Starting application with pm2..."
pm2 start ./ecosystem.config.js

echo "Verifying application process..."
pm2 describe smart-grocery-assistant # This will show details or error if not running

echo "Deployment script finished."

exit 0
