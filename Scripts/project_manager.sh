#!/bin/bash

# 🎯 StryVr Project Manager
# Quick TODO integration and script organization

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🎯 StryVr Project Manager${NC}"
echo "=============================="

# Show TODO progress
if [ -f "TODO_APP_STORE_READY.md" ]; then
    PROGRESS=$(grep -A 5 "Overall Progress:" TODO_APP_STORE_READY.md | head -1 | sed 's/.*~\([0-9]*\)%.*/\1/' 2>/dev/null || echo "0")
    COMPLETED=$(grep -c "✅" TODO_APP_STORE_READY.md 2>/dev/null || echo "0")
    PENDING=$(grep -c "⏳\|🟡\|🔴" TODO_APP_STORE_READY.md 2>/dev/null || echo "0")
    
    echo -e "${GREEN}📊 TODO Progress: ~${PROGRESS}% Complete${NC}"
    echo -e "${GREEN}✅ Completed: $COMPLETED${NC}"
    echo -e "${YELLOW}⏳ Pending: $PENDING${NC}"
    
    # Check for critical tasks
    CRITICAL=$(grep -c "🔴" TODO_APP_STORE_READY.md 2>/dev/null || echo "0")
    if [ "$CRITICAL" -gt 0 ]; then
        echo -e "${RED}🚨 Critical tasks: $CRITICAL${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ TODO file not found${NC}"
fi

echo ""
echo -e "${BLUE}🚀 Quick Commands:${NC}"
echo "  ./Scripts/start_stryvr.sh          - Start development"
echo "  ./Scripts/daily_maintenance.sh     - Daily maintenance"
echo "  ./Scripts/safe_build.sh            - Safe build"
echo "  ./Scripts/app_store_workflow.sh    - App Store prep"
echo ""
echo -e "${YELLOW}💡 Run: ./Scripts/project_manager.sh --help for more options${NC}"
