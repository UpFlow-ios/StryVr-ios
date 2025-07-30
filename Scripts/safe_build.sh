#!/bin/bash

# 🛡️ Safe Build Manager for StryVr
# Prevents multiple Xcode builds from running simultaneously
# Protects system performance

set -e

# Configuration
LOCK_FILE="/tmp/stryvr_safe_build.lock"
BUILD_LOG="build-$(date +%Y%m%d-%H%M%S).log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🛡️ StryVr Safe Build Manager${NC}"
echo "=================================="

# Check if build is already running
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE" 2>/dev/null || echo "unknown")
    echo -e "${RED}❌ Build already running (PID: $PID)${NC}"
    echo -e "${YELLOW}💡 To force start: rm $LOCK_FILE${NC}"
    exit 1
fi

# Create lock file
echo $$ > "$LOCK_FILE"
echo -e "${GREEN}✅ Build lock created (PID: $$)${NC}"

# Cleanup function
cleanup() {
    rm -f "$LOCK_FILE"
    echo -e "${GREEN}✅ Build lock removed${NC}"
}

# Set up cleanup on exit
trap cleanup EXIT
trap 'cleanup; echo -e "${RED}❌ Build interrupted${NC}"; exit 1' INT TERM

# Kill any existing Xcode processes
echo -e "${YELLOW}🔄 Stopping existing Xcode processes...${NC}"
pkill -f "xcodebuild" 2>/dev/null || true
pkill -f "Xcode" 2>/dev/null || true
sleep 2

echo -e "${BLUE}🚀 Starting StryVr build...${NC}"
echo -e "${BLUE}📝 Log: $BUILD_LOG${NC}"

# Run the build
xcodebuild -project SupportingFiles/StryVr.xcodeproj \
    -scheme StryVr \
    -destination 'platform=iOS Simulator,id=100CCA36-46ED-4520-977A-E5686C88BBBD' \
    build 2>&1 | tee "$BUILD_LOG"

BUILD_EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo -e "${BLUE}📊 Build Results:${NC}"
echo "Exit code: $BUILD_EXIT_CODE"

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful!${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    echo -e "${YELLOW}📋 Check log: $BUILD_LOG${NC}"
fi

exit $BUILD_EXIT_CODE 