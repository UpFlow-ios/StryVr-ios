#!/bin/bash

# 📋 Show StryVr Script Organization
# Displays all scripts organized by category

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}📋 StryVr Script Organization${NC}"
echo "====================================="

# Show TODO progress
if [ -f "TODO_APP_STORE_READY.md" ]; then
    PROGRESS=$(grep -A 5 "Overall Progress:" TODO_APP_STORE_READY.md | head -1 | sed 's/.*~\([0-9]*\)%.*/\1/' 2>/dev/null || echo "0")
    echo -e "${GREEN}📊 TODO Progress: ~${PROGRESS}% Complete${NC}"
    echo ""
fi

# Development Scripts
echo -e "${BLUE}🚀 Development & Build${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/development/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# Monitoring Scripts
echo -e "${BLUE}📊 Monitoring & Health${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/monitoring/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# Security Scripts
echo -e "${BLUE}🔐 Security & Compliance${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/security/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# App Store Scripts
echo -e "${BLUE}📱 App Store & Marketing${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/appstore/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# AI Scripts
echo -e "${BLUE}🤖 AI & Automation${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/ai/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# Documentation Scripts
echo -e "${BLUE}📚 Documentation & Setup${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/docs/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# Enterprise Scripts
echo -e "${BLUE}🏢 Enterprise & Analytics${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/enterprise/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""

# Utility Scripts
echo -e "${BLUE}🔧 Utilities${NC}"
echo "--------------------------------"
ls -1 Scripts/categories/utils/ 2>/dev/null | sed 's/^/  /' || echo "  No scripts found"

echo ""
echo -e "${YELLOW}💡 Quick Commands:${NC}"
echo "  ./Scripts/project_manager.sh     - Project overview"
echo "  ./Scripts/start_stryvr.sh        - Start development"
echo "  ./Scripts/daily_maintenance.sh   - Daily maintenance"
echo "  ./Scripts/safe_build.sh          - Safe build"
echo ""
echo -e "${CYAN}📁 Total Scripts: $(find Scripts -name "*.sh" | wc -l | tr -d ' ')${NC}"
