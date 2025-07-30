#!/bin/bash

# 🔧 Backend Health Agent for StryVr
# This script monitors Node.js server and Firebase health

echo "🔧 Running StryVr Backend Health Agent..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_section() {
    echo -e "${PURPLE}📋 $1${NC}"
    echo "=================================="
}

print_subsection() {
    echo -e "${CYAN}🔧 $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Not in the stryvr-ios repository root. Please run this script from the project root."
    exit 1
fi

# Get current date for logging
CURRENT_DATE=$(date +%Y-%m-%d)
BACKEND_HEALTH_LOG="backend_health_${CURRENT_DATE}.log"

echo "🔧 StryVr Backend Health Report - $CURRENT_DATE" > "$BACKEND_HEALTH_LOG"
echo "=============================================" >> "$BACKEND_HEALTH_LOG"

print_section "1. NODE.JS SERVER HEALTH"
echo "1. NODE.JS SERVER HEALTH" >> "$BACKEND_HEALTH_LOG"

# Check backend directory
print_subsection "Checking backend directory..."
echo "Checking backend directory..." >> "$BACKEND_HEALTH_LOG"

if [ -d "backend" ]; then
    print_status "Backend directory exists"
    echo "✅ Backend directory exists" >> "$BACKEND_HEALTH_LOG"
else
    print_error "Backend directory not found"
    echo "❌ Backend directory not found" >> "$BACKEND_HEALTH_LOG"
    exit 1
fi

# Check backend files
print_subsection "Checking backend files..."
echo "Checking backend files..." >> "$BACKEND_HEALTH_LOG"

BACKEND_FILES=(
    "backend/package.json"
    "backend/server.js"
    "backend/.env"
)

for file in "${BACKEND_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_status "✅ $file exists"
        echo "✅ $file exists" >> "$BACKEND_HEALTH_LOG"
    else
        print_warning "⚠️ $file missing"
        echo "⚠️ $file missing" >> "$BACKEND_HEALTH_LOG"
    fi
done

# Check Node.js dependencies
print_subsection "Checking Node.js dependencies..."
echo "Checking Node.js dependencies..." >> "$BACKEND_HEALTH_LOG"

cd backend

if [ -d "node_modules" ]; then
    print_status "Node modules installed"
    echo "✅ Node modules installed" >> "../$BACKEND_HEALTH_LOG"
else
    print_warning "Node modules not installed"
    echo "⚠️ Node modules not installed" >> "../$BACKEND_HEALTH_LOG"
    print_info "Installing dependencies..."
    npm install
fi

# Check for dependency vulnerabilities
print_subsection "Checking for security vulnerabilities..."
echo "Checking for security vulnerabilities..." >> "../$BACKEND_HEALTH_LOG"

VULNERABILITIES=$(npm audit --audit-level=moderate 2>/dev/null | grep -c "found" || echo "0")
if [ "$VULNERABILITIES" -eq 0 ]; then
    print_status "No security vulnerabilities found"
    echo "✅ No security vulnerabilities found" >> "../$BACKEND_HEALTH_LOG"
else
    print_warning "Security vulnerabilities found: $VULNERABILITIES"
    echo "⚠️ Security vulnerabilities found: $VULNERABILITIES" >> "../$BACKEND_HEALTH_LOG"
    print_info "Run: npm audit fix"
fi

cd ..

print_section "2. FIREBASE HEALTH CHECK"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "2. FIREBASE HEALTH CHECK" >> "$BACKEND_HEALTH_LOG"

# Check Firebase configuration
print_subsection "Checking Firebase configuration..."
echo "Checking Firebase configuration..." >> "$BACKEND_HEALTH_LOG"

# Check environment variables
FIREBASE_VARS=(
    "FIREBASE_PROJECT_ID"
    "FIREBASE_PRIVATE_KEY"
    "FIREBASE_CLIENT_EMAIL"
    "FIREBASE_STORAGE_BUCKET"
)

if [ -f "backend/.env" ]; then
    print_status "Environment file exists"
    echo "✅ Environment file exists" >> "$BACKEND_HEALTH_LOG"
    
    for var in "${FIREBASE_VARS[@]}"; do
        if grep -q "^${var}=" backend/.env; then
            print_status "✅ $var configured"
            echo "✅ $var configured" >> "$BACKEND_HEALTH_LOG"
        else
            print_warning "⚠️ $var not configured"
            echo "⚠️ $var not configured" >> "$BACKEND_HEALTH_LOG"
        fi
    done
else
    print_error "Environment file not found"
    echo "❌ Environment file not found" >> "$BACKEND_HEALTH_LOG"
fi

# Check Firebase config files
print_subsection "Checking Firebase config files..."
echo "Checking Firebase config files..." >> "$BACKEND_HEALTH_LOG"

if [ -f "backend/GoogleService-Info.plist" ]; then
    print_warning "Firebase config file found in backend - should be in iOS project"
    echo "⚠️ Firebase config file found in backend - should be in iOS project" >> "$BACKEND_HEALTH_LOG"
else
    print_status "Firebase config properly managed"
    echo "✅ Firebase config properly managed" >> "$BACKEND_HEALTH_LOG"
fi

print_section "3. API ENDPOINT TESTING"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "3. API ENDPOINT TESTING" >> "$BACKEND_HEALTH_LOG"

# Test API endpoints
print_subsection "Testing API endpoints..."
echo "Testing API endpoints..." >> "$BACKEND_HEALTH_LOG"

# Check if server is running
if curl -s http://localhost:5000/api/test > /dev/null 2>&1; then
    print_status "Backend server is running"
    echo "✅ Backend server is running" >> "$BACKEND_HEALTH_LOG"
    
    # Test specific endpoints
    ENDPOINTS=(
        "http://localhost:5000/api/test"
        "http://localhost:5000/api/test-storage"
    )
    
    for endpoint in "${ENDPOINTS[@]}"; do
        if curl -s "$endpoint" > /dev/null 2>&1; then
            print_status "✅ $endpoint responding"
            echo "✅ $endpoint responding" >> "$BACKEND_HEALTH_LOG"
        else
            print_warning "⚠️ $endpoint not responding"
            echo "⚠️ $endpoint not responding" >> "$BACKEND_HEALTH_LOG"
        fi
    done
else
    print_warning "Backend server not running"
    echo "⚠️ Backend server not running" >> "$BACKEND_HEALTH_LOG"
    print_info "Start server with: cd backend && npm start"
fi

print_section "4. PERFORMANCE MONITORING"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "4. PERFORMANCE MONITORING" >> "$BACKEND_HEALTH_LOG"

# Performance checks
print_subsection "Checking performance metrics..."
echo "Checking performance metrics..." >> "$BACKEND_HEALTH_LOG"

# Check system resources
MEMORY_USAGE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
MEMORY_GB=$((MEMORY_USAGE * 4096 / 1024 / 1024 / 1024))
print_info "Available memory: ${MEMORY_GB}GB"
echo "Available memory: ${MEMORY_GB}GB" >> "$BACKEND_HEALTH_LOG"

DISK_SPACE=$(df -h . | tail -1 | awk '{print $4}')
print_info "Available disk space: $DISK_SPACE"
echo "Available disk space: $DISK_SPACE" >> "$BACKEND_HEALTH_LOG"

# Check for large log files
LARGE_LOGS=$(find . -name "*.log" -size +10M 2>/dev/null | wc -l)
if [ "$LARGE_LOGS" -gt 0 ]; then
    print_warning "Large log files found: $LARGE_LOGS"
    echo "⚠️ Large log files found: $LARGE_LOGS" >> "$BACKEND_HEALTH_LOG"
else
    print_status "No large log files found"
    echo "✅ No large log files found" >> "$BACKEND_HEALTH_LOG"
fi

print_section "5. ERROR MONITORING"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "5. ERROR MONITORING" >> "$BACKEND_HEALTH_LOG"

# Check for recent errors
print_subsection "Checking for recent errors..."
echo "Checking for recent errors..." >> "$BACKEND_HEALTH_LOG"

# Check for error logs
ERROR_LOGS=$(find . -name "*error*log*" -mtime -1 2>/dev/null | head -5)
if [ -n "$ERROR_LOGS" ]; then
    print_warning "Recent error logs found"
    echo "⚠️ Recent error logs found" >> "$BACKEND_HEALTH_LOG"
    echo "$ERROR_LOGS" >> "$BACKEND_HEALTH_LOG"
else
    print_status "No recent error logs found"
    echo "✅ No recent error logs found" >> "$BACKEND_HEALTH_LOG"
fi

# Check for crash logs
CRASH_LOGS=$(find . -name "*crash*" -mtime -1 2>/dev/null | head -5)
if [ -n "$CRASH_LOGS" ]; then
    print_warning "Recent crash logs found"
    echo "⚠️ Recent crash logs found" >> "$BACKEND_HEALTH_LOG"
    echo "$CRASH_LOGS" >> "$BACKEND_HEALTH_LOG"
else
    print_status "No recent crash logs found"
    echo "✅ No recent crash logs found" >> "$BACKEND_HEALTH_LOG"
fi

print_section "6. BACKEND AUTOMATION"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "6. BACKEND AUTOMATION" >> "$BACKEND_HEALTH_LOG"

# Create backend automation scripts
print_subsection "Creating backend automation..."
echo "Creating backend automation..." >> "$BACKEND_HEALTH_LOG"

# Create backend restart script
cat > Scripts/restart_backend.sh << 'EOF'
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
EOF

chmod +x Scripts/restart_backend.sh
print_status "Backend restart script created"

# Create backend monitoring script
cat > Scripts/monitor_backend.sh << 'EOF'
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
EOF

chmod +x Scripts/monitor_backend.sh
print_status "Backend monitoring script created"

print_section "7. HEALTH RECOMMENDATIONS"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "7. HEALTH RECOMMENDATIONS" >> "$BACKEND_HEALTH_LOG"

print_subsection "Backend health recommendations..."
echo "Backend health recommendations..." >> "$BACKEND_HEALTH_LOG"

echo "1. Set up automated monitoring" >> "$BACKEND_HEALTH_LOG"
echo "2. Implement health check endpoints" >> "$BACKEND_HEALTH_LOG"
echo "3. Set up error alerting" >> "$BACKEND_HEALTH_LOG"
echo "4. Monitor performance metrics" >> "$BACKEND_HEALTH_LOG"
echo "5. Set up automated restarts" >> "$BACKEND_HEALTH_LOG"

print_info "Backend health recommendations:"
echo "1. Set up automated monitoring"
echo "2. Implement health check endpoints"
echo "3. Set up error alerting"
echo "4. Monitor performance metrics"
echo "5. Set up automated restarts"

print_section "8. SUMMARY & NEXT STEPS"
echo "" >> "$BACKEND_HEALTH_LOG"
echo "8. SUMMARY & NEXT STEPS" >> "$BACKEND_HEALTH_LOG"

print_status "Backend health check completed!"
echo "✅ Backend health check completed!" >> "$BACKEND_HEALTH_LOG"

print_info "📋 Backend action items:"
echo "📋 Backend action items:" >> "$BACKEND_HEALTH_LOG"
echo "1. Monitor backend: ./Scripts/monitor_backend.sh" >> "$BACKEND_HEALTH_LOG"
echo "2. Restart backend: ./Scripts/restart_backend.sh" >> "$BACKEND_HEALTH_LOG"
echo "3. Fix vulnerabilities: cd backend && npm audit fix" >> "$BACKEND_HEALTH_LOG"
echo "4. Set up automated monitoring" >> "$BACKEND_HEALTH_LOG"
echo "5. Configure error alerting" >> "$BACKEND_HEALTH_LOG"

print_info "📊 Backend health report saved to: $BACKEND_HEALTH_LOG"
echo "📊 Backend health report saved to: $BACKEND_HEALTH_LOG" >> "$BACKEND_HEALTH_LOG"

echo ""
print_warning "💡 Backend Health Pro Tips:"
echo "   - Monitor server uptime continuously"
echo "   - Set up automated restarts on failure"
echo "   - Monitor API response times"
echo "   - Keep dependencies updated"
echo "   - Set up proper logging and error tracking"

echo ""
print_status "🎉 Backend health agent completed successfully!"
echo ""
echo "📞 Need help? Contact: joedormond@stryvr.app" 