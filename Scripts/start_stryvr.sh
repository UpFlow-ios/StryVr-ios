#!/bin/bash

# StryVr Complete Startup Script
# Starts backend server and provides iOS app options

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 StryVr Complete Startup${NC}"
echo "=============================="

# Check if backend is already running
if curl -s http://localhost:5000/api/test > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend already running on port 5000${NC}"
else
    echo -e "${YELLOW}🔥 Starting StryVr Backend Server...${NC}"
    
    # Check if backend dependencies are corrupted
    if [ ! -f "backend/node_modules/google-auth-library/package.json" ]; then
        echo -e "${YELLOW}⚠️  Backend dependencies may be corrupted. Running fix...${NC}"
        ./Scripts/fix_backend.sh &
        BACKEND_PID=$!
    else
        # Start backend in background
        cd backend
        npm start > ../server.log 2>&1 &
        BACKEND_PID=$!
        cd ..
    fi
    
    # Wait for backend to start
    echo -e "${YELLOW}⏳ Waiting for backend to start...${NC}"
    for i in {1..30}; do
        if curl -s http://localhost:5000/api/test > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Backend started successfully!${NC}"
            break
        fi
        sleep 1
    done
    
    if [ $i -eq 30 ]; then
        echo -e "${RED}❌ Backend failed to start${NC}"
        echo -e "${YELLOW}💡 This is normal - the iOS app works without backend${NC}"
        echo -e "${YELLOW}💡 Run './Scripts/fix_backend.sh' manually if needed${NC}"
    fi
fi

# Test backend endpoints
echo -e "${YELLOW}🔍 Testing backend endpoints...${NC}"
if curl -s http://localhost:5000/api/test | grep -q "StryVr Backend"; then
    echo -e "${GREEN}✅ Health check passed${NC}"
else
    echo -e "${RED}❌ Health check failed${NC}"
fi

# Show startup options
echo -e "${BLUE}🎯 StryVr is ready! Choose your next step:${NC}"
echo ""
echo -e "${GREEN}🚀 RECOMMENDED: Run iOS App${NC}"
echo -e "${YELLOW}1️⃣  Open Xcode Project${NC}"
echo "   open SupportingFiles/StryVr.xcodeproj"
echo ""
echo -e "${YELLOW}2️⃣  Quick Build Test${NC}"
echo "   cd SupportingFiles && xcodebuild -project StryVr.xcodeproj -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build"
echo ""
echo -e "${YELLOW}3️⃣  Fix Backend (if needed)${NC}"
echo "   ./Scripts/fix_backend.sh"
echo ""
echo -e "${YELLOW}4️⃣  Test Backend APIs${NC}"
echo "   curl http://localhost:5000/api/test"
echo ""
echo -e "${YELLOW}5️⃣  View Server Logs${NC}"
echo "   tail -f server.log"
echo ""

# Save backend PID for later use
echo $BACKEND_PID > .backend_pid 2>/dev/null || true

echo -e "${GREEN}🎉 StryVr startup complete!${NC}"
echo -e "${BLUE}📱 Backend: http://localhost:5000${NC}"
echo -e "${BLUE}📱 iOS App: Ready to run in Xcode${NC}"
echo ""
echo -e "${YELLOW}💡 Tip: Keep this terminal open to monitor the backend${NC}"
echo -e "${YELLOW}💡 Tip: Use 'tail -f server.log' to see backend logs${NC}" 