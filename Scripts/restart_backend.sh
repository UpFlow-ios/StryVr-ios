#!/bin/bash
# Backend restart script

echo "🔄 Restarting StryVr backend..."

# Kill existing Node.js processes
pkill -f "node.*server.js" 2>/dev/null

# Wait a moment
sleep 2

# Start backend
cd backend
npm start
