#!/bin/bash

# 📅 Weekly Maintenance Script for StryVr
# This script handles all weekly tasks: security, testing, agents, and project health

echo "📅 Running weekly maintenance for StryVr..."

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
WEEKLY_LOG="weekly_maintenance_${CURRENT_DATE}.log"

echo "📅 Weekly Maintenance Report - $CURRENT_DATE" > "$WEEKLY_LOG"
echo "=============================================" >> "$WEEKLY_LOG"

print_section "1. SECURITY AUDIT & UPDATES"
echo "1. SECURITY AUDIT & UPDATES" >> "$WEEKLY_LOG"

# Run security update script
print_subsection "Running security audit..."
echo "Running security audit..." >> "$WEEKLY_LOG"
if ./Scripts/security_update.sh; then
    print_status "Security audit completed successfully"
    echo "✅ Security audit completed successfully" >> "$WEEKLY_LOG"
else
    print_warning "Security audit had issues - check manually"
    echo "⚠️ Security audit had issues - check manually" >> "$WEEKLY_LOG"
fi

print_section "2. DEPENDENCY UPDATES"
echo "" >> "$WEEKLY_LOG"
echo "2. DEPENDENCY UPDATES" >> "$WEEKLY_LOG"

# Check for outdated packages
print_subsection "Checking for outdated packages..."
echo "Checking for outdated packages..." >> "$WEEKLY_LOG"

# Root directory
if [ -f "package.json" ]; then
    print_info "Root directory packages:"
    echo "Root directory packages:" >> "$WEEKLY_LOG"
    npm outdated >> "$WEEKLY_LOG" 2>&1 || print_status "All packages up to date"
fi

# Backend directory
if [ -d "backend" ] && [ -f "backend/package.json" ]; then
    print_info "Backend packages:"
    echo "Backend packages:" >> "$WEEKLY_LOG"
    cd backend
    npm outdated >> "../$WEEKLY_LOG" 2>&1 || print_status "All packages up to date"
    cd ..
fi

# Swift Package Manager (if applicable)
print_subsection "Checking Swift Package Manager..."
echo "Checking Swift Package Manager..." >> "$WEEKLY_LOG"
if [ -d "SupportingFiles" ]; then
    print_info "Swift packages are managed by Xcode - check manually in Xcode"
    echo "Swift packages are managed by Xcode - check manually in Xcode" >> "$WEEKLY_LOG"
fi

print_section "3. BUILD & TESTING"
echo "" >> "$WEEKLY_LOG"
echo "3. BUILD & TESTING" >> "$WEEKLY_LOG"

# Test backend
print_subsection "Testing backend..."
echo "Testing backend..." >> "$WEEKLY_LOG"
if [ -d "backend" ]; then
    cd backend
    if npm test >> "../$WEEKLY_LOG" 2>&1; then
        print_status "Backend tests passed"
        echo "✅ Backend tests passed" >> "../$WEEKLY_LOG"
    else
        print_warning "Backend tests failed - check manually"
        echo "⚠️ Backend tests failed - check manually" >> "../$WEEKLY_LOG"
    fi
    cd ..
else
    print_info "No backend tests configured"
    echo "No backend tests configured" >> "$WEEKLY_LOG"
fi

# Check Xcode build
print_subsection "Checking Xcode build status..."
echo "Checking Xcode build status..." >> "$WEEKLY_LOG"
if [ -d "SupportingFiles" ]; then
    print_info "Xcode build check - run manually:"
    echo "Xcode build check - run manually:" >> "$WEEKLY_LOG"
    echo "  1. Open SupportingFiles/StryVr.xcodeproj" >> "$WEEKLY_LOG"
    echo "  2. Clean build folder (Cmd+Shift+K)" >> "$WEEKLY_LOG"
    echo "  3. Build project (Cmd+B)" >> "$WEEKLY_LOG"
    echo "  4. Run on simulator (Cmd+R)" >> "$WEEKLY_LOG"
    print_warning "Manual Xcode testing required"
else
    print_error "Xcode project not found"
    echo "❌ Xcode project not found" >> "$WEEKLY_LOG"
fi

print_section "4. AGENT MANAGEMENT"
echo "" >> "$WEEKLY_LOG"
echo "4. AGENT MANAGEMENT" >> "$WEEKLY_LOG"

# Check existing agents
print_subsection "Current agent status..."
echo "Current agent status..." >> "$WEEKLY_LOG"

if [ -f "Docs/AGENTS.md" ]; then
    print_info "Agent documentation found"
    echo "Agent documentation found" >> "$WEEKLY_LOG"
    
    # Count active agents
    ACTIVE_AGENTS=$(grep -c "✅ Active" Docs/AGENTS.md 2>/dev/null || echo "0")
    print_info "Active agents: $ACTIVE_AGENTS"
    echo "Active agents: $ACTIVE_AGENTS" >> "$WEEKLY_LOG"
else
    print_warning "No agent documentation found"
    echo "No agent documentation found" >> "$WEEKLY_LOG"
fi

# Agent recommendations
print_subsection "Agent recommendations..."
echo "Agent recommendations..." >> "$WEEKLY_LOG"

echo "Recommended agents to add:" >> "$WEEKLY_LOG"
echo "1. Social Media Manager Agent" >> "$WEEKLY_LOG"
echo "   - Automate LinkedIn, Instagram, Twitter posts" >> "$WEEKLY_LOG"
echo "   - Schedule content calendar" >> "$WEEKLY_LOG"
echo "   - Monitor engagement metrics" >> "$WEEKLY_LOG"

echo "2. Customer Support Agent" >> "$WEEKLY_LOG"
echo "   - Handle common user inquiries" >> "$WEEKLY_LOG"
echo "   - Route complex issues to human support" >> "$WEEKLY_LOG"
echo "   - Generate support documentation" >> "$WEEKLY_LOG"

echo "3. Analytics Agent" >> "$WEEKLY_LOG"
echo "   - Track app usage metrics" >> "$WEEKLY_LOG"
echo "   - Generate weekly performance reports" >> "$WEEKLY_LOG"
echo "   - Identify user behavior patterns" >> "$WEEKLY_LOG"

echo "4. Content Marketing Agent" >> "$WEEKLY_LOG"
echo "   - Create blog posts and articles" >> "$WEEKLY_LOG"
echo "   - Generate email newsletters" >> "$WEEKLY_LOG"
echo "   - Optimize SEO content" >> "$WEEKLY_LOG"

print_info "Consider adding these agents for better automation"

print_section "5. PROJECT HEALTH CHECK"
echo "" >> "$WEEKLY_LOG"
echo "5. PROJECT HEALTH CHECK" >> "$WEEKLY_LOG"

# Check repository status
print_subsection "Repository health..."
echo "Repository health..." >> "$WEEKLY_LOG"

# Check for uncommitted changes
if git status --porcelain | grep -q .; then
    print_warning "Uncommitted changes detected"
    echo "⚠️ Uncommitted changes detected" >> "$WEEKLY_LOG"
    git status --porcelain >> "$WEEKLY_LOG"
else
    print_status "Repository is clean"
    echo "✅ Repository is clean" >> "$WEEKLY_LOG"
fi

# Check for large files
print_subsection "Checking for large files..."
echo "Checking for large files..." >> "$WEEKLY_LOG"
find . -type f -size +10M -not -path "./.git/*" -not -path "./node_modules/*" >> "$WEEKLY_LOG" 2>/dev/null || print_status "No large files found"

# Check documentation completeness
print_subsection "Documentation check..."
echo "Documentation check..." >> "$WEEKLY_LOG"
DOCS_COUNT=$(find Docs/ -name "*.md" | wc -l)
print_info "Documentation files: $DOCS_COUNT"
echo "Documentation files: $DOCS_COUNT" >> "$WEEKLY_LOG"

print_section "6. APP STORE & CONSUMER OPTIMIZATION"
echo "" >> "$WEEKLY_LOG"
echo "6. APP STORE & CONSUMER OPTIMIZATION" >> "$WEEKLY_LOG"

# Run App Store optimization
print_subsection "Running App Store optimization..."
echo "Running App Store optimization..." >> "$WEEKLY_LOG"
if ./Scripts/app_store_optimizer.sh; then
    print_status "App Store optimization completed successfully"
    echo "✅ App Store optimization completed successfully" >> "$WEEKLY_LOG"
else
    print_warning "App Store optimization had issues - check manually"
    echo "⚠️ App Store optimization had issues - check manually" >> "$WEEKLY_LOG"
fi

print_subsection "Consumer feature testing..."
echo "Consumer feature testing..." >> "$WEEKLY_LOG"
if ./Scripts/test_consumer_features.sh; then
    print_status "Consumer feature testing completed"
    echo "✅ Consumer feature testing completed" >> "$WEEKLY_LOG"
else
    print_warning "Consumer feature testing had issues"
    echo "⚠️ Consumer feature testing had issues" >> "$WEEKLY_LOG"
fi

print_section "7. MARKETING & OUTREACH"
echo "" >> "$WEEKLY_LOG"
echo "7. MARKETING & OUTREACH" >> "$WEEKLY_LOG"

print_subsection "Social media tasks..."
echo "Social media tasks..." >> "$WEEKLY_LOG"

echo "Weekly social media checklist:" >> "$WEEKLY_LOG"
echo "1. LinkedIn: Post 2-3 times per week" >> "$WEEKLY_LOG"
echo "2. Instagram: Post 3-4 times per week" >> "$WEEKLY_LOG"
echo "3. Twitter: Post 5-7 times per week" >> "$WEEKLY_LOG"
echo "4. Engage with community posts" >> "$WEEKLY_LOG"
echo "5. Share development progress" >> "$WEEKLY_LOG"

print_subsection "Content creation..."
echo "Content creation..." >> "$WEEKLY_LOG"

echo "Weekly content tasks:" >> "$WEEKLY_LOG"
echo "1. Write 1 blog post about StryVr features" >> "$WEEKLY_LOG"
echo "2. Create 2-3 social media graphics" >> "$WEEKLY_LOG"
echo "3. Record 1 short demo video" >> "$WEEKLY_LOG"
echo "4. Update website content" >> "$WEEKLY_LOG"

print_section "8. NEXT WEEK PLANNING"
echo "" >> "$WEEKLY_LOG"
echo "8. NEXT WEEK PLANNING" >> "$WEEKLY_LOG"

print_subsection "Priority tasks for next week..."
echo "Priority tasks for next week..." >> "$WEEKLY_LOG"

echo "Development priorities:" >> "$WEEKLY_LOG"
echo "1. Complete App Store submission preparation" >> "$WEEKLY_LOG"
echo "2. Test all features thoroughly" >> "$WEEKLY_LOG"
echo "3. Fix any remaining bugs" >> "$WEEKLY_LOG"
echo "4. Optimize app performance" >> "$WEEKLY_LOG"

echo "Marketing priorities:" >> "$WEEKLY_LOG"
echo "1. Launch social media campaign" >> "$WEEKLY_LOG"
echo "2. Reach out to potential users" >> "$WEEKLY_LOG"
echo "3. Create demo videos" >> "$WEEKLY_LOG"
echo "4. Prepare press release" >> "$WEEKLY_LOG"

print_section "9. SUMMARY & RECOMMENDATIONS"
echo "" >> "$WEEKLY_LOG"
echo "9. SUMMARY & RECOMMENDATIONS" >> "$WEEKLY_LOG"

print_status "Weekly maintenance completed!"
echo "✅ Weekly maintenance completed!" >> "$WEEKLY_LOG"

print_info "📋 Action items for this week:"
echo "📋 Action items for this week:" >> "$WEEKLY_LOG"
echo "1. Review security report" >> "$WEEKLY_LOG"
echo "2. Test Xcode build manually" >> "$WEEKLY_LOG"
echo "3. Consider adding recommended agents" >> "$WEEKLY_LOG"
echo "4. Create social media content" >> "$WEEKLY_LOG"
echo "5. Plan next week's priorities" >> "$WEEKLY_LOG"

print_info "📊 Weekly report saved to: $WEEKLY_LOG"
echo "📊 Weekly report saved to: $WEEKLY_LOG" >> "$WEEKLY_LOG"

echo ""
print_warning "💡 Pro Tips:"
echo "   - Run this script every Monday morning"
echo "   - Review the generated log file"
echo "   - Update agent documentation as needed"
echo "   - Schedule time for manual testing"
echo "   - Keep social media content calendar updated"

echo ""
print_status "🎉 Weekly maintenance completed successfully!"
echo ""
echo "📞 Need help? Contact: joedormond@stryvr.app"
echo "🔗 Follow StryVr: @stryvr_app on Instagram" 