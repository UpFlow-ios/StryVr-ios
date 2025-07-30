#!/bin/bash

# 📅 Daily Maintenance Script for StryVr
# This script handles daily tasks: quick checks, monitoring, and immediate issues

echo "📅 Running daily maintenance for StryVr..."

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
DAILY_LOG="daily_maintenance_${CURRENT_DATE}.log"

echo "📅 Daily Maintenance Report - $CURRENT_DATE" > "$DAILY_LOG"
echo "===========================================" >> "$DAILY_LOG"

print_section "1. QUICK SECURITY CHECK"
echo "1. QUICK SECURITY CHECK" >> "$DAILY_LOG"

# Quick security audit
print_subsection "Running quick security check..."
echo "Running quick security check..." >> "$DAILY_LOG"

# Check for exposed secrets
SECRETS_CHECK=$(grep -r -i "password\|key\|secret\|token" . --exclude-dir=.git --exclude-dir=node_modules 2>/dev/null | grep -v "example\|placeholder" | wc -l)
if [ "$SECRETS_CHECK" -eq 0 ]; then
    print_status "No exposed secrets found"
    echo "✅ No exposed secrets found" >> "$DAILY_LOG"
else
    print_warning "Potential secrets found: $SECRETS_CHECK"
    echo "⚠️ Potential secrets found: $SECRETS_CHECK" >> "$DAILY_LOG"
fi

# Check environment files
if [ -f "backend/.env" ]; then
    print_status "Environment file exists"
    echo "✅ Environment file exists" >> "$DAILY_LOG"
else
    print_warning "Environment file not found"
    echo "⚠️ Environment file not found" >> "$DAILY_LOG"
fi

print_section "2. BUILD STATUS CHECK"
echo "" >> "$DAILY_LOG"
echo "2. BUILD STATUS CHECK" >> "$DAILY_LOG"

# Quick build check
print_subsection "Checking build status..."
echo "Checking build status..." >> "$DAILY_LOG"

# Check for build errors in recent logs
RECENT_BUILD_ERRORS=$(find . -name "*build*log*" -mtime -1 2>/dev/null | head -1)
if [ -n "$RECENT_BUILD_ERRORS" ]; then
    print_warning "Recent build logs found - check for errors"
    echo "⚠️ Recent build logs found - check for errors" >> "$DAILY_LOG"
else
    print_status "No recent build logs found"
    echo "✅ No recent build logs found" >> "$DAILY_LOG"
fi

# Check Xcode project
if [ -d "SupportingFiles" ]; then
    print_status "Xcode project found"
    echo "✅ Xcode project found" >> "$DAILY_LOG"
else
    print_error "Xcode project not found"
    echo "❌ Xcode project not found" >> "$DAILY_LOG"
fi

print_section "3. GIT STATUS CHECK"
echo "" >> "$DAILY_LOG"
echo "3. GIT STATUS CHECK" >> "$DAILY_LOG"

# Check git status
print_subsection "Checking git status..."
echo "Checking git status..." >> "$DAILY_LOG"

# Check for uncommitted changes
if git status --porcelain | grep -q .; then
    print_warning "Uncommitted changes detected"
    echo "⚠️ Uncommitted changes detected" >> "$DAILY_LOG"
    git status --porcelain >> "$DAILY_LOG"
else
    print_status "Repository is clean"
    echo "✅ Repository is clean" >> "$DAILY_LOG"
fi

# Check for unpushed commits
UNPUSHED_COMMITS=$(git log --oneline origin/main..HEAD 2>/dev/null | wc -l)
if [ "$UNPUSHED_COMMITS" -gt 0 ]; then
    print_warning "Unpushed commits: $UNPUSHED_COMMITS"
    echo "⚠️ Unpushed commits: $UNPUSHED_COMMITS" >> "$DAILY_LOG"
else
    print_status "All commits pushed"
    echo "✅ All commits pushed" >> "$DAILY_LOG"
fi

print_section "4. AI SERVICE STATUS"
echo "" >> "$DAILY_LOG"
echo "4. AI SERVICE STATUS" >> "$DAILY_LOG"

# Quick AI service check
print_subsection "Checking AI services..."
echo "Checking AI services..." >> "$DAILY_LOG"

# Check AI services
AI_SERVICES=(
    "AIRecommendationService.swift"
    "AIProfileValidator.swift"
    "AIGreetingManager.swift"
)

for service in "${AI_SERVICES[@]}"; do
    if [ -f "StryVr/Services/$service" ]; then
        print_status "✅ $service"
        echo "✅ $service" >> "$DAILY_LOG"
    else
        print_warning "⚠️ $service (not found)"
        echo "⚠️ $service (not found)" >> "$DAILY_LOG"
    fi
done

print_section "5. CONSUMER FEATURE CHECK"
echo "" >> "$DAILY_LOG"
echo "5. CONSUMER FEATURE CHECK" >> "$DAILY_LOG"

# Quick consumer feature check
print_subsection "Checking consumer features..."
echo "Checking consumer features..." >> "$DAILY_LOG"

# Check key consumer features
CONSUMER_FEATURES=(
    "Onboarding"
    "Profile"
    "Challenges"
    "Feed"
)

for feature in "${CONSUMER_FEATURES[@]}"; do
    if [ -d "StryVr/Views/$feature" ]; then
        print_status "✅ $feature"
        echo "✅ $feature" >> "$DAILY_LOG"
    else
        print_warning "⚠️ $feature (not found)"
        echo "⚠️ $feature (not found)" >> "$DAILY_LOG"
    fi
done

print_section "6. ENTERPRISE FEATURE CHECK"
echo "" >> "$DAILY_LOG"
echo "6. ENTERPRISE FEATURE CHECK" >> "$DAILY_LOG"

# Quick enterprise feature check
print_subsection "Checking enterprise features..."
echo "Checking enterprise features..." >> "$DAILY_LOG"

# Check key enterprise features
ENTERPRISE_FEATURES=(
    "EmployeeInsights"
    "Reports"
    "Analytics"
)

for feature in "${ENTERPRISE_FEATURES[@]}"; do
    if [ -d "StryVr/Views/$feature" ]; then
        print_status "✅ $feature"
        echo "✅ $feature" >> "$DAILY_LOG"
    else
        print_warning "⚠️ $feature (not found)"
        echo "⚠️ $feature (not found)" >> "$DAILY_LOG"
    fi
done

print_section "7. QUICK PERFORMANCE CHECK"
echo "" >> "$DAILY_LOG"
echo "7. QUICK PERFORMANCE CHECK" >> "$DAILY_LOG"

# Quick performance check
print_subsection "Checking performance..."
echo "Checking performance..." >> "$DAILY_LOG"

# Check system resources
MEMORY_USAGE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
MEMORY_GB=$((MEMORY_USAGE * 4096 / 1024 / 1024 / 1024))
print_info "Available memory: ${MEMORY_GB}GB"
echo "Available memory: ${MEMORY_GB}GB" >> "$DAILY_LOG"

DISK_SPACE=$(df -h . | tail -1 | awk '{print $4}')
print_info "Available disk space: $DISK_SPACE"
echo "Available disk space: $DISK_SPACE" >> "$DAILY_LOG"

# Check for large files
LARGE_FILES=$(find . -type f -size +50M -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null | wc -l)
if [ "$LARGE_FILES" -gt 0 ]; then
    print_warning "Large files found: $LARGE_FILES"
    echo "⚠️ Large files found: $LARGE_FILES" >> "$DAILY_LOG"
else
    print_status "No large files found"
    echo "✅ No large files found" >> "$DAILY_LOG"
fi

print_section "8. DAILY TASKS"
echo "" >> "$DAILY_LOG"
echo "8. DAILY TASKS" >> "$DAILY_LOG"

print_subsection "Daily task checklist..."
echo "Daily task checklist..." >> "$DAILY_LOG"

echo "Daily tasks to complete:" >> "$DAILY_LOG"
echo "1. Check GitHub notifications" >> "$DAILY_LOG"
echo "2. Review any new issues or PRs" >> "$DAILY_LOG"
echo "3. Test app on simulator" >> "$DAILY_LOG"
echo "4. Check social media engagement" >> "$DAILY_LOG"
echo "5. Monitor App Store reviews (if live)" >> "$DAILY_LOG"

print_info "Daily tasks to complete:"
echo "1. Check GitHub notifications"
echo "2. Review any new issues or PRs"
echo "3. Test app on simulator"
echo "4. Check social media engagement"
echo "5. Monitor App Store reviews (if live)"

print_section "9. QUICK FIXES"
echo "" >> "$DAILY_LOG"
echo "9. QUICK FIXES" >> "$DAILY_LOG"

# Quick fixes for common issues
print_subsection "Quick fixes for common issues..."
echo "Quick fixes for common issues..." >> "$DAILY_LOG"

echo "Common quick fixes:" >> "$DAILY_LOG"
echo "1. Build issues: Clean build folder (Cmd+Shift+K)" >> "$DAILY_LOG"
echo "2. Git issues: git pull origin main" >> "$DAILY_LOG"
echo "3. Dependencies: npm install in backend/" >> "$DAILY_LOG"
echo "4. Cache issues: Clear DerivedData" >> "$DAILY_LOG"
echo "5. Performance: Restart Xcode" >> "$DAILY_LOG"

print_info "Common quick fixes:"
echo "1. Build issues: Clean build folder (Cmd+Shift+K)"
echo "2. Git issues: git pull origin main"
echo "3. Dependencies: npm install in backend/"
echo "4. Cache issues: Clear DerivedData"
echo "5. Performance: Restart Xcode"

print_section "10. SUMMARY"
echo "" >> "$DAILY_LOG"
echo "10. SUMMARY" >> "$DAILY_LOG"

print_status "Daily maintenance completed!"
echo "✅ Daily maintenance completed!" >> "$DAILY_LOG"

print_info "📋 Quick action items:"
echo "📋 Quick action items:" >> "$DAILY_LOG"
echo "1. Review the daily log: $DAILY_LOG" >> "$DAILY_LOG"
echo "2. Address any warnings or errors" >> "$DAILY_LOG"
echo "3. Complete daily tasks checklist" >> "$DAILY_LOG"
echo "4. Test app functionality" >> "$DAILY_LOG"
echo "5. Check for urgent issues" >> "$DAILY_LOG"

print_info "📊 Daily report saved to: $DAILY_LOG"
echo "📊 Daily report saved to: $DAILY_LOG" >> "$DAILY_LOG"

echo ""
print_warning "💡 Daily Pro Tips:"
echo "   - Run this script every morning"
echo "   - Address issues immediately"
echo "   - Keep commits small and frequent"
echo "   - Test features as you develop"
echo "   - Monitor user feedback"

echo ""
print_status "🎉 Daily maintenance completed successfully!"
echo ""
echo "📞 Need help? Contact: upflowapp@gmail.com" 