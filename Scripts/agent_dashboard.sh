#!/bin/bash

# 🎛️ Unified Agent Dashboard for StryVr
# This script provides a single dashboard for all agents

echo "🎛️ StryVr Unified Agent Dashboard"
echo "=================================="

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

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)
DASHBOARD_LOG="agent_dashboard_${CURRENT_DATE}.log"

echo "🎛️ StryVr Agent Dashboard - $CURRENT_DATE" > "$DASHBOARD_LOG"
echo "=========================================" >> "$DASHBOARD_LOG"

print_section "AGENT STATUS OVERVIEW"
echo "AGENT STATUS OVERVIEW" >> "$DASHBOARD_LOG"

# Define all agents (compatible with older bash versions)
AGENTS_DAILY="Daily Maintenance Agent"
AGENTS_WEEKLY="Weekly Maintenance Agent"
AGENTS_MONITOR="Automated Monitoring Agent"
AGENTS_SECURITY="Security Update Agent"
AGENTS_IOS="iOS Build Optimizer Agent"
AGENTS_AI="AI Service Monitor Agent"
AGENTS_ENTERPRISE="Enterprise Analytics Agent"
AGENTS_APPSTORE="App Store Optimizer Agent"
AGENTS_DEPLOY="Deployment Agent"
AGENTS_MARKETING="Marketing Automation Agent"
AGENTS_BACKEND="Backend Health Agent"
AGENTS_DOCS="Documentation Agent"
AGENTS_ASSETS="Asset Management Agent"

# Check agent availability
print_subsection "Checking agent availability..."
echo "Checking agent availability..." >> "$DASHBOARD_LOG"

AVAILABLE_AGENTS=0
TOTAL_AGENTS=13

# Check each agent individually
if [ -f "Scripts/daily_maintenance.sh" ]; then
    print_status "✅ $AGENTS_DAILY"
    echo "✅ $AGENTS_DAILY" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_DAILY"
    echo "❌ $AGENTS_DAILY" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/weekly_maintenance.sh" ]; then
    print_status "✅ $AGENTS_WEEKLY"
    echo "✅ $AGENTS_WEEKLY" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_WEEKLY"
    echo "❌ $AGENTS_WEEKLY" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/automated_monitoring.sh" ]; then
    print_status "✅ $AGENTS_MONITOR"
    echo "✅ $AGENTS_MONITOR" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_MONITOR"
    echo "❌ $AGENTS_MONITOR" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/security_update.sh" ]; then
    print_status "✅ $AGENTS_SECURITY"
    echo "✅ $AGENTS_SECURITY" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_SECURITY"
    echo "❌ $AGENTS_SECURITY" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/ios_build_optimizer.sh" ]; then
    print_status "✅ $AGENTS_IOS"
    echo "✅ $AGENTS_IOS" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_IOS"
    echo "❌ $AGENTS_IOS" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/ai_service_monitor.sh" ]; then
    print_status "✅ $AGENTS_AI"
    echo "✅ $AGENTS_AI" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_AI"
    echo "❌ $AGENTS_AI" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/enterprise_analytics.sh" ]; then
    print_status "✅ $AGENTS_ENTERPRISE"
    echo "✅ $AGENTS_ENTERPRISE" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_ENTERPRISE"
    echo "❌ $AGENTS_ENTERPRISE" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/app_store_optimizer.sh" ]; then
    print_status "✅ $AGENTS_APPSTORE"
    echo "✅ $AGENTS_APPSTORE" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_APPSTORE"
    echo "❌ $AGENTS_APPSTORE" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/deployment_agent.sh" ]; then
    print_status "✅ $AGENTS_DEPLOY"
    echo "✅ $AGENTS_DEPLOY" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_DEPLOY"
    echo "❌ $AGENTS_DEPLOY" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/marketing_automation_agent.sh" ]; then
    print_status "✅ $AGENTS_MARKETING"
    echo "✅ $AGENTS_MARKETING" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_MARKETING"
    echo "❌ $AGENTS_MARKETING" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/backend_health_agent.sh" ]; then
    print_status "✅ $AGENTS_BACKEND"
    echo "✅ $AGENTS_BACKEND" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_BACKEND"
    echo "❌ $AGENTS_BACKEND" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/documentation_agent.sh" ]; then
    print_status "✅ $AGENTS_DOCS"
    echo "✅ $AGENTS_DOCS" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_DOCS"
    echo "❌ $AGENTS_DOCS" >> "$DASHBOARD_LOG"
fi

if [ -f "Scripts/asset_management_agent.sh" ]; then
    print_status "✅ $AGENTS_ASSETS"
    echo "✅ $AGENTS_ASSETS" >> "$DASHBOARD_LOG"
    ((AVAILABLE_AGENTS++))
else
    print_error "❌ $AGENTS_ASSETS"
    echo "❌ $AGENTS_ASSETS" >> "$DASHBOARD_LOG"
fi

print_section "AGENT COVERAGE"
echo "" >> "$DASHBOARD_LOG"
echo "AGENT COVERAGE" >> "$DASHBOARD_LOG"

COVERAGE_PERCENTAGE=$((AVAILABLE_AGENTS * 100 / TOTAL_AGENTS))
print_info "Agent Coverage: $AVAILABLE_AGENTS/$TOTAL_AGENTS ($COVERAGE_PERCENTAGE%)"
echo "Agent Coverage: $AVAILABLE_AGENTS/$TOTAL_AGENTS ($COVERAGE_PERCENTAGE%)" >> "$DASHBOARD_LOG"

if [ "$COVERAGE_PERCENTAGE" -eq 100 ]; then
    print_status "🎉 All agents available!"
    echo "🎉 All agents available!" >> "$DASHBOARD_LOG"
elif [ "$COVERAGE_PERCENTAGE" -ge 80 ]; then
    print_status "✅ Good agent coverage"
    echo "✅ Good agent coverage" >> "$DASHBOARD_LOG"
elif [ "$COVERAGE_PERCENTAGE" -ge 60 ]; then
    print_warning "⚠️ Moderate agent coverage"
    echo "⚠️ Moderate agent coverage" >> "$DASHBOARD_LOG"
else
    print_error "❌ Low agent coverage"
    echo "❌ Low agent coverage" >> "$DASHBOARD_LOG"
fi

print_section "QUICK ACCESS COMMANDS"
echo "" >> "$DASHBOARD_LOG"
echo "QUICK ACCESS COMMANDS" >> "$DASHBOARD_LOG"

print_subsection "Available npm scripts:"
echo "Available npm scripts:" >> "$DASHBOARD_LOG"

echo "📋 Maintenance:" >> "$DASHBOARD_LOG"
echo "  npm run daily      - Daily maintenance" >> "$DASHBOARD_LOG"
echo "  npm run weekly     - Weekly maintenance" >> "$DASHBOARD_LOG"
echo "  npm run monitor    - Automated monitoring" >> "$DASHBOARD_LOG"
echo "  npm run security   - Security updates" >> "$DASHBOARD_LOG"

echo "📱 Development:" >> "$DASHBOARD_LOG"
echo "  npm run ios        - iOS build optimization" >> "$DASHBOARD_LOG"
echo "  npm run ai         - AI service monitoring" >> "$DASHBOARD_LOG"
echo "  npm run enterprise - Enterprise analytics" >> "$DASHBOARD_LOG"
echo "  npm run appstore   - App Store optimization" >> "$DASHBOARD_LOG"

echo "🚀 Deployment:" >> "$DASHBOARD_LOG"
echo "  npm run deploy     - Deployment automation" >> "$DASHBOARD_LOG"
echo "  npm run backend    - Backend health check" >> "$DASHBOARD_LOG"

echo "📢 Marketing:" >> "$DASHBOARD_LOG"
echo "  npm run marketing  - Marketing automation" >> "$DASHBOARD_LOG"
echo "  npm run assets     - Asset management" >> "$DASHBOARD_LOG"

echo "📚 Documentation:" >> "$DASHBOARD_LOG"
echo "  npm run docs       - Documentation management" >> "$DASHBOARD_LOG"

print_info "📋 Maintenance:"
echo "  npm run daily      - Daily maintenance"
echo "  npm run weekly     - Weekly maintenance"
echo "  npm run monitor    - Automated monitoring"
echo "  npm run security   - Security updates"

print_info "📱 Development:"
echo "  npm run ios        - iOS build optimization"
echo "  npm run ai         - AI service monitoring"
echo "  npm run enterprise - Enterprise analytics"
echo "  npm run appstore   - App Store optimization"

print_info "🚀 Deployment:"
echo "  npm run deploy     - Deployment automation"
echo "  npm run backend    - Backend health check"

print_info "📢 Marketing:"
echo "  npm run marketing  - Marketing automation"
echo "  npm run assets     - Asset management"

print_info "📚 Documentation:"
echo "  npm run docs       - Documentation management"

print_section "RECENT LOGS"
echo "" >> "$DASHBOARD_LOG"
echo "RECENT LOGS" >> "$DASHBOARD_LOG"

# Check for recent log files
print_subsection "Recent agent logs:"
echo "Recent agent logs:" >> "$DASHBOARD_LOG"

RECENT_LOGS=$(find . -name "*_${CURRENT_DATE}.log" -type f 2>/dev/null | head -5)
if [ -n "$RECENT_LOGS" ]; then
    for log in $RECENT_LOGS; do
        LOG_SIZE=$(du -h "$log" | cut -f1)
        print_info "📄 $log ($LOG_SIZE)"
        echo "📄 $log ($LOG_SIZE)" >> "$DASHBOARD_LOG"
    done
else
    print_warning "No recent logs found for today"
    echo "No recent logs found for today" >> "$DASHBOARD_LOG"
fi

print_section "SYSTEM STATUS"
echo "" >> "$DASHBOARD_LOG"
echo "SYSTEM STATUS" >> "$DASHBOARD_LOG"

# Quick system status check
print_subsection "System status:"
echo "System status:" >> "$DASHBOARD_LOG"

# Check git status
GIT_STATUS=$(git status --porcelain | wc -l)
if [ "$GIT_STATUS" -eq 0 ]; then
    print_status "✅ Git repository clean"
    echo "✅ Git repository clean" >> "$DASHBOARD_LOG"
else
    print_warning "⚠️ Git repository has $GIT_STATUS changes"
    echo "⚠️ Git repository has $GIT_STATUS changes" >> "$DASHBOARD_LOG"
fi

# Check disk space
DISK_SPACE=$(df -h . | tail -1 | awk '{print $4}')
print_info "💾 Available disk space: $DISK_SPACE"
echo "💾 Available disk space: $DISK_SPACE" >> "$DASHBOARD_LOG"

# Check memory
MEMORY_USAGE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
MEMORY_GB=$((MEMORY_USAGE * 4096 / 1024 / 1024 / 1024))
print_info "🧠 Available memory: ${MEMORY_GB}GB"
echo "🧠 Available memory: ${MEMORY_GB}GB" >> "$DASHBOARD_LOG"

print_section "QUICK ACTIONS"
echo "" >> "$DASHBOARD_LOG"
echo "QUICK ACTIONS" >> "$DASHBOARD_LOG"

print_subsection "Quick actions menu:"
echo "Quick actions menu:" >> "$DASHBOARD_LOG"

echo "1. Run daily maintenance" >> "$DASHBOARD_LOG"
echo "2. Check system status" >> "$DASHBOARD_LOG"
echo "3. Run security audit" >> "$DASHBOARD_LOG"
echo "4. Generate documentation" >> "$DASHBOARD_LOG"
echo "5. Check marketing assets" >> "$DASHBOARD_LOG"
echo "6. Monitor backend health" >> "$DASHBOARD_LOG"
echo "7. Optimize iOS build" >> "$DASHBOARD_LOG"
echo "8. Exit" >> "$DASHBOARD_LOG"

print_info "Quick actions menu:"
echo "1. Run daily maintenance"
echo "2. Check system status"
echo "3. Run security audit"
echo "4. Generate documentation"
echo "5. Check marketing assets"
echo "6. Monitor backend health"
echo "7. Optimize iOS build"
echo "8. Exit"

echo ""
read -p "Select an action (1-8): " choice

case $choice in
    1)
        echo "Running daily maintenance..."
        npm run daily
        ;;
    2)
        echo "Checking system status..."
        npm run monitor
        ;;
    3)
        echo "Running security audit..."
        npm run security
        ;;
    4)
        echo "Generating documentation..."
        npm run docs
        ;;
    5)
        echo "Checking marketing assets..."
        npm run assets
        ;;
    6)
        echo "Monitoring backend health..."
        npm run backend
        ;;
    7)
        echo "Optimizing iOS build..."
        npm run ios
        ;;
    8)
        echo "Exiting dashboard..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

print_section "SUMMARY"
echo "" >> "$DASHBOARD_LOG"
echo "SUMMARY" >> "$DASHBOARD_LOG"

print_status "Dashboard completed!"
echo "✅ Dashboard completed!" >> "$DASHBOARD_LOG"

print_info "📊 Dashboard report saved to: $DASHBOARD_LOG"
echo "📊 Dashboard report saved to: $DASHBOARD_LOG" >> "$DASHBOARD_LOG"

echo ""
print_warning "💡 Dashboard Pro Tips:"
echo "   - Run this dashboard daily to check agent status"
echo "   - Use npm scripts for quick access to agents"
echo "   - Monitor logs for any issues"
echo "   - Keep all agents up to date"
echo "   - Use quick actions for common tasks"

echo ""
print_status "🎉 Agent dashboard completed successfully!"
echo ""
echo "📞 Need help? Contact: joedormond@stryvr.app" 