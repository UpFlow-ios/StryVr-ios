#!/bin/bash
# Backend monitoring script

echo "📊 Monitoring StryVr backend..."

# Check if server is running
if curl -s http://localhost:5000/api/test > /dev/null 2>&1; then
    echo "✅ Backend is running"
    
    # Get response time
    RESPONSE_TIME=$(curl -w "%{time_total}" -s -o /dev/null http://localhost:5000/api/test)
    echo "⏱️ Response time: ${RESPONSE_TIME}s"
    
    # Check memory usage
    if pgrep -f "node.*server.js" > /dev/null; then
        PID=$(pgrep -f "node.*server.js")
        MEMORY=$(ps -o rss= -p $PID | awk '{print $1/1024 " MB"}')
        echo "💾 Memory usage: $MEMORY"
    fi
else
    echo "❌ Backend is not running"
    echo "🚀 Starting backend..."
    cd backend && npm start &
fi
