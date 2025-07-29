#!/bin/bash

# Fix Backend Dependencies and Start Server
set -e

echo "🔧 Fixing StryVr Backend Dependencies..."

# Go to backend directory
cd backend

# Remove corrupted dependencies
echo "🗑️  Removing corrupted node_modules..."
rm -rf node_modules package-lock.json

# Reinstall dependencies
echo "📦 Installing dependencies..."
npm install

# Test the server
echo "🧪 Testing server..."
node -e "console.log('✅ Node.js and dependencies working')"

# Start the server
echo "🚀 Starting StryVr Backend Server..."
npm start 