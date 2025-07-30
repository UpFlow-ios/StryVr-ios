#!/bin/bash

# 🤖 Automated Monitoring System for StryVr
# This script runs all critical monitoring tasks automatically

echo "🤖 Starting automated monitoring for StryVr..."

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

# Get current date and time for logging
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_TIME=$(date +%H:%M:%S)
MONITORING_LOG="automated_monitoring_${CURRENT_DATE}.log"

echo "🤖 Automated Monitoring Report - $CURRENT_DATE $CURRENT_TIME" > "$MONITORING_LOG"
echo "=========================================================" >> "$MONITORING_LOG"

print_section "1. CRITICAL SYSTEM MONITORING"
echo "1. CRITICAL SYSTEM MONITORING" >> "$MONITORING_LOG"

# Monitor critical systems
print_subsection "Monitoring critical systems..."
echo "Monitoring critical systems..." >> "$MONITORING_LOG"

# Check if backend is running
if pgrep -f "node.*server.js" > /dev/null; then
    print_status "Backend server is running"
    echo "✅ Backend server is running" >> "$MONITORING_LOG"
else
    print_warning "Backend server is not running"
    echo "⚠️ Backend server is not running" >> "$MONITORING_LOG"
fi

# Check if Xcode is running
if pgrep -f "Xcode" > /dev/null; then
    print_status "Xcode is running"
    echo "✅ Xcode is running" >> "$MONITORING_LOG"
else
    print_info "Xcode is not running"
    echo "ℹ️ Xcode is not running" >> "$MONITORING_LOG"
fi

print_section "2. AI SERVICE MONITORING"
echo "" >> "$MONITORING_LOG"
echo "2. AI SERVICE MONITORING" >> "$MONITORING_LOG"

# Monitor AI services
print_subsection "Monitoring AI services..."
echo "Monitoring AI services..." >> "$MONITORING_LOG"

# Check HuggingFace API
if [ -f "backend/.env" ]; then
    source backend/.env
    if [ -n "$HUGGINGFACE_API_KEY" ]; then
        print_status "HuggingFace API key configured"
        echo "✅ HuggingFace API key configured" >> "$MONITORING_LOG"
    else
        print_warning "HuggingFace API key not found"
        echo "⚠️ HuggingFace API key not found" >> "$MONITORING_LOG"
    fi
else
    print_warning "Environment file not found"
    echo "⚠️ Environment file not found" >> "$MONITORING_LOG"
fi

# Check AI service files
AI_SERVICES=(
    "AIRecommendationService.swift"
    "AIProfileValidator.swift"
    "AIGreetingManager.swift"
)

for service in "${AI_SERVICES[@]}"; do
    if [ -f "StryVr/Services/$service" ]; then
        print_status "✅ $service"
        echo "✅ $service" >> "$MONITORING_LOG"
    else
        print_warning "⚠️ $service (not found)"
        echo "⚠️ $service (not found)" >> "$MONITORING_LOG"
    fi
done

print_section "3. BUILD SYSTEM MONITORING"
echo "" >> "$MONITORING_LOG"
echo "3. BUILD SYSTEM MONITORING" >> "$MONITORING_LOG"

# Monitor build system
print_subsection "Monitoring build system..."
echo "Monitoring build system..." >> "$MONITORING_LOG"

# Check for build errors
RECENT_BUILD_ERRORS=$(find . -name "*build*log*" -mtime -1 2>/dev/null | head -1)
if [ -n "$RECENT_BUILD_ERRORS" ]; then
    print_warning "Recent build logs found - check for errors"
    echo "⚠️ Recent build logs found - check for errors" >> "$MONITORING_LOG"
else
    print_status "No recent build logs found"
    echo "✅ No recent build logs found" >> "$MONITORING_LOG"
fi

# Check Xcode project
if [ -d "SupportingFiles" ]; then
    print_status "Xcode project found"
    echo "✅ Xcode project found" >> "$MONITORING_LOG"
else
    print_error "Xcode project not found"
    echo "❌ Xcode project not found" >> "$MONITORING_LOG"
fi

print_section "4. SECURITY MONITORING"
echo "" >> "$MONITORING_LOG"
echo "4. SECURITY MONITORING" >> "$MONITORING_LOG"

# Monitor security
print_subsection "Monitoring security..."
echo "Monitoring security..." >> "$MONITORING_LOG"

# Check for exposed secrets
SECRETS_CHECK=$(grep -r -i "password\|key\|secret\|token" . --exclude-dir=.git --exclude-dir=node_modules 2>/dev/null | grep -v "example\|placeholder" | wc -l)
if [ "$SECRETS_CHECK" -eq 0 ]; then
    print_status "No exposed secrets found"
    echo "✅ No exposed secrets found" >> "$MONITORING_LOG"
else
    print_warning "Potential secrets found: $SECRETS_CHECK"
    echo "⚠️ Potential secrets found: $SECRETS_CHECK" >> "$MONITORING_LOG"
fi

# Check environment files
if [ -f "backend/.env" ]; then
    print_status "Environment file exists"
    echo "✅ Environment file exists" >> "$MONITORING_LOG"
else
    print_warning "Environment file not found"
    echo "⚠️ Environment file not found" >> "$MONITORING_LOG"
fi

print_section "5. GIT STATUS MONITORING"
echo "" >> "$MONITORING_LOG"
echo "5. GIT STATUS MONITORING" >> "$MONITORING_LOG"

# Monitor git status
print_subsection "Monitoring git status..."
echo "Monitoring git status..." >> "$MONITORING_LOG"

# Check for uncommitted changes
if git status --porcelain | grep -q .; then
    print_warning "Uncommitted changes detected"
    echo "⚠️ Uncommitted changes detected" >> "$MONITORING_LOG"
    git status --porcelain >> "$MONITORING_LOG"
else
    print_status "Repository is clean"
    echo "✅ Repository is clean" >> "$MONITORING_LOG"
fi

# Check for unpushed commits
UNPUSHED_COMMITS=$(git log --oneline origin/main..HEAD 2>/dev/null | wc -l)
if [ "$UNPUSHED_COMMITS" -gt 0 ]; then
    print_warning "Unpushed commits: $UNPUSHED_COMMITS"
    echo "⚠️ Unpushed commits: $UNPUSHED_COMMITS" >> "$MONITORING_LOG"
else
    print_status "All commits pushed"
    echo "✅ All commits pushed" >> "$MONITORING_LOG"
fi

print_section "6. PERFORMANCE MONITORING"
echo "" >> "$MONITORING_LOG"
echo "6. PERFORMANCE MONITORING" >> "$MONITORING_LOG"

# Monitor performance
print_subsection "Monitoring performance..."
echo "Monitoring performance..." >> "$MONITORING_LOG"

# Check system resources
MEMORY_USAGE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
MEMORY_GB=$((MEMORY_USAGE * 4096 / 1024 / 1024 / 1024))
print_info "Available memory: ${MEMORY_GB}GB"
echo "Available memory: ${MEMORY_GB}GB" >> "$MONITORING_LOG"

DISK_SPACE=$(df -h . | tail -1 | awk '{print $4}')
print_info "Available disk space: $DISK_SPACE"
echo "Available disk space: $DISK_SPACE" >> "$MONITORING_LOG"

# Check for large files
LARGE_FILES=$(find . -type f -size +50M -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null | wc -l)
if [ "$LARGE_FILES" -gt 0 ]; then
    print_warning "Large files found: $LARGE_FILES"
    echo "⚠️ Large files found: $LARGE_FILES" >> "$MONITORING_LOG"
else
    print_status "No large files found"
    echo "✅ No large files found" >> "$MONITORING_LOG"
fi

print_section "7. FEATURE MONITORING"
echo "" >> "$MONITORING_LOG"
echo "7. FEATURE MONITORING" >> "$MONITORING_LOG"

# Monitor features
print_subsection "Monitoring features..."
echo "Monitoring features..." >> "$MONITORING_LOG"

# Check consumer features
CONSUMER_FEATURES=(
    "Onboarding"
    "Profile"
    "Challenges"
    "Feed"
)

echo "Consumer Features:" >> "$MONITORING_LOG"
for feature in "${CONSUMER_FEATURES[@]}"; do
    if [ -d "StryVr/Views/$feature" ]; then
        print_status "✅ $feature"
        echo "✅ $feature" >> "$MONITORING_LOG"
    else
        print_warning "⚠️ $feature (not found)"
        echo "⚠️ $feature (not found)" >> "$MONITORING_LOG"
    fi
done

# Check enterprise features
ENTERPRISE_FEATURES=(
    "EmployeeInsights"
    "Reports"
    "Analytics"
)

echo "" >> "$MONITORING_LOG"
echo "Enterprise Features:" >> "$MONITORING_LOG"
for feature in "${ENTERPRISE_FEATURES[@]}"; do
    if [ -d "StryVr/Views/$feature" ]; then
        print_status "✅ $feature"
        echo "✅ $feature" >> "$MONITORING_LOG"
    else
        print_warning "⚠️ $feature (not found)"
        echo "⚠️ $feature (not found)" >> "$MONITORING_LOG"
    fi
done

print_section "8. AUTOMATED ACTIONS"
echo "" >> "$MONITORING_LOG"
echo "8. AUTOMATED ACTIONS" >> "$MONITORING_LOG"

# Perform automated actions
print_subsection "Performing automated actions..."
echo "Performing automated actions..." >> "$MONITORING_LOG"

# Clean up old logs
OLD_LOGS=$(find . -name "*.log" -mtime +7 2>/dev/null | wc -l)
if [ "$OLD_LOGS" -gt 0 ]; then
    print_info "Cleaning up old logs: $OLD_LOGS files"
    echo "ℹ️ Cleaning up old logs: $OLD_LOGS files" >> "$MONITORING_LOG"
    find . -name "*.log" -mtime +7 -delete 2>/dev/null
    print_status "Old logs cleaned up"
    echo "✅ Old logs cleaned up" >> "$MONITORING_LOG"
else
    print_status "No old logs to clean up"
    echo "✅ No old logs to clean up" >> "$MONITORING_LOG"
fi

# Check for security updates
if [ -f "backend/package.json" ]; then
    print_info "Checking for security updates..."
    echo "ℹ️ Checking for security updates..." >> "$MONITORING_LOG"
    cd backend
    if npm audit --audit-level=moderate > /dev/null 2>&1; then
        print_status "No security vulnerabilities found"
        echo "✅ No security vulnerabilities found" >> "../$MONITORING_LOG"
    else
        print_warning "Security vulnerabilities detected"
        echo "⚠️ Security vulnerabilities detected" >> "../$MONITORING_LOG"
    fi
    cd ..
else
    print_info "No backend package.json found"
    echo "ℹ️ No backend package.json found" >> "$MONITORING_LOG"
fi

print_section "9. ALERT SYSTEM"
echo "" >> "$MONITORING_LOG"
echo "9. ALERT SYSTEM" >> "$MONITORING_LOG"

# Generate alerts
print_subsection "Generating alerts..."
echo "Generating alerts..." >> "$MONITORING_LOG"

ALERTS=()

# Check for critical issues
if [ "$SECRETS_CHECK" -gt 0 ]; then
    ALERTS+=("CRITICAL: $SECRETS_CHECK potential secrets found")
fi

if [ "$LARGE_FILES" -gt 0 ]; then
    ALERTS+=("WARNING: $LARGE_FILES large files detected")
fi

if [ "$UNPUSHED_COMMITS" -gt 0 ]; then
    ALERTS+=("WARNING: $UNPUSHED_COMMITS unpushed commits")
fi

if [ ${#ALERTS[@]} -eq 0 ]; then
    print_status "No alerts generated"
    echo "✅ No alerts generated" >> "$MONITORING_LOG"
else
    print_warning "Alerts generated:"
    echo "⚠️ Alerts generated:" >> "$MONITORING_LOG"
    for alert in "${ALERTS[@]}"; do
        echo "  - $alert" >> "$MONITORING_LOG"
        print_warning "  - $alert"
    done
fi

print_section "10. SUMMARY & RECOMMENDATIONS"
echo "" >> "$MONITORING_LOG"
echo "10. SUMMARY & RECOMMENDATIONS" >> "$MONITORING_LOG"

print_status "Automated monitoring completed!"
echo "✅ Automated monitoring completed!" >> "$MONITORING_LOG"

print_info "📋 Recommendations:"
echo "📋 Recommendations:" >> "$MONITORING_LOG"

if [ "$SECRETS_CHECK" -gt 0 ]; then
    echo "1. Review and secure exposed secrets" >> "$MONITORING_LOG"
    print_warning "1. Review and secure exposed secrets"
fi

if [ "$LARGE_FILES" -gt 0 ]; then
    echo "2. Optimize large files for better performance" >> "$MONITORING_LOG"
    print_warning "2. Optimize large files for better performance"
fi

if [ "$UNPUSHED_COMMITS" -gt 0 ]; then
    echo "3. Push pending commits to remote repository" >> "$MONITORING_LOG"
    print_warning "3. Push pending commits to remote repository"
fi

echo "4. Run weekly maintenance script for comprehensive check" >> "$MONITORING_LOG"
print_info "4. Run weekly maintenance script for comprehensive check"

echo "5. Monitor AI service performance regularly" >> "$MONITORING_LOG"
print_info "5. Monitor AI service performance regularly"

print_info "📊 Monitoring report saved to: $MONITORING_LOG"
echo "📊 Monitoring report saved to: $MONITORING_LOG" >> "$MONITORING_LOG"

echo ""
print_warning "💡 Monitoring Pro Tips:"
echo "   - Run this script every hour for critical systems"
echo "   - Set up automated alerts for critical issues"
echo "   - Monitor AI API costs regularly"
echo "   - Track build performance over time"
echo "   - Keep security monitoring active"

echo ""
print_status "🎉 Automated monitoring completed successfully!"
echo ""
echo "📞 Need help? Contact: upflowapp@gmail.com" 