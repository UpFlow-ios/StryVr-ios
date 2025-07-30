#!/bin/bash

# 📚 Documentation Agent for StryVr
# This script keeps documentation updated automatically

echo "📚 Running StryVr Documentation Agent..."

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
DOCS_LOG="documentation_agent_${CURRENT_DATE}.log"

echo "📚 StryVr Documentation Agent Report - $CURRENT_DATE" > "$DOCS_LOG"
echo "=================================================" >> "$DOCS_LOG"

print_section "1. DOCUMENTATION AUDIT"
echo "1. DOCUMENTATION AUDIT" >> "$DOCS_LOG"

# Check documentation structure
print_subsection "Checking documentation structure..."
echo "Checking documentation structure..." >> "$DOCS_LOG"

# Check Docs directory
if [ -d "Docs" ]; then
    print_status "Docs directory exists"
    echo "✅ Docs directory exists" >> "$DOCS_LOG"
else
    print_warning "Docs directory missing"
    echo "⚠️ Docs directory missing" >> "$DOCS_LOG"
    mkdir -p Docs
    print_status "Created Docs directory"
fi

# Check key documentation files
DOCS_FILES=(
    "README.md"
    "CONTRIBUTING.md"
    "LICENSE"
    "CONTACT.md"
    "Docs/README.md"
    "Docs/AGENT_MANAGEMENT.md"
    "Docs/API_REFERENCE.md"
    "Docs/CHANGELOG.md"
    "Docs/APP_STORE_DEPLOYMENT.md"
    "Docs/SECURITY_INCIDENT_RESPONSE.md"
    "Docs/GITHUB_VISIBILITY_GUIDE.md"
    "Docs/COMPREHENSIVE_AGENT_ANALYSIS.md"
)

for file in "${DOCS_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_status "✅ $file exists"
        echo "✅ $file exists" >> "$DOCS_LOG"
    else
        print_warning "⚠️ $file missing"
        echo "⚠️ $file missing" >> "$DOCS_LOG"
    fi
done

print_section "2. README.md VALIDATION"
echo "" >> "$DOCS_LOG"
echo "2. README.md VALIDATION" >> "$DOCS_LOG"

# Validate README.md
print_subsection "Validating README.md..."
echo "Validating README.md..." >> "$DOCS_LOG"

if [ -f "README.md" ]; then
    # Check for key sections
    README_SECTIONS=(
        "About stryvr"
        "Key Features"
        "Tech Stack"
        "Getting Started"
        "Configuration"
        "Project Structure"
        "Contributing"
        "Roadmap"
        "Security"
        "Support & Contact"
    )
    
    for section in "${README_SECTIONS[@]}"; do
        if grep -q "$section" README.md; then
            print_status "✅ $section found"
            echo "✅ $section found" >> "$DOCS_LOG"
        else
            print_warning "⚠️ $section missing"
            echo "⚠️ $section missing" >> "$DOCS_LOG"
        fi
    done
    
    # Check for broken links
    BROKEN_LINKS=$(grep -o '\[.*\](.*)' README.md | grep -v "http" | wc -l)
    if [ "$BROKEN_LINKS" -eq 0 ]; then
        print_status "No broken links found"
        echo "✅ No broken links found" >> "$DOCS_LOG"
    else
        print_warning "Potential broken links: $BROKEN_LINKS"
        echo "⚠️ Potential broken links: $BROKEN_LINKS" >> "$DOCS_LOG"
    fi
else
    print_error "README.md not found"
    echo "❌ README.md not found" >> "$DOCS_LOG"
fi

print_section "3. CHANGELOG GENERATION"
echo "" >> "$DOCS_LOG"
echo "3. CHANGELOG GENERATION" >> "$DOCS_LOG"

# Generate changelog
print_subsection "Generating changelog..."
echo "Generating changelog..." >> "$DOCS_LOG"

# Get recent commits for changelog
RECENT_COMMITS=$(git log --oneline --since="1 week ago" | head -10)
if [ -n "$RECENT_COMMITS" ]; then
    print_status "Recent commits found"
    echo "✅ Recent commits found" >> "$DOCS_LOG"
    
    # Create changelog entry
    cat > Docs/CHANGELOG_UPDATE.md << EOF
# Changelog Update - $CURRENT_DATE

## Recent Changes

$(echo "$RECENT_COMMITS" | sed 's/^/- /')

## Summary
- Total commits this week: $(echo "$RECENT_COMMITS" | wc -l)
- Generated on: $CURRENT_DATE

EOF
    
    print_status "Changelog update created"
    echo "✅ Changelog update created" >> "$DOCS_LOG"
else
    print_warning "No recent commits found"
    echo "⚠️ No recent commits found" >> "$DOCS_LOG"
fi

print_section "4. API DOCUMENTATION"
echo "" >> "$DOCS_LOG"
echo "4. API DOCUMENTATION" >> "$DOCS_LOG"

# Update API documentation
print_subsection "Updating API documentation..."
echo "Updating API documentation..." >> "$DOCS_LOG"

# Check backend API endpoints
if [ -f "backend/server.js" ]; then
    # Extract API endpoints from server.js
    API_ENDPOINTS=$(grep -E "app\.(get|post|put|delete)" backend/server.js | sed 's/.*app\.\(get\|post\|put\|delete\)(\([^,]*\).*/\1 \2/' | sort | uniq)
    
    if [ -n "$API_ENDPOINTS" ]; then
        print_status "API endpoints found"
        echo "✅ API endpoints found" >> "$DOCS_LOG"
        
        # Create API documentation
        cat > Docs/API_REFERENCE_UPDATE.md << EOF
# API Reference Update - $CURRENT_DATE

## Available Endpoints

$(echo "$API_ENDPOINTS" | while read method path; do
    echo "### $method $path"
    echo ""
    echo "**Description**: [Add description]"
    echo "**Parameters**: [Add parameters]"
    echo "**Response**: [Add response format]"
    echo ""
done)

## Summary
- Total endpoints: $(echo "$API_ENDPOINTS" | wc -l)
- Updated on: $CURRENT_DATE

EOF
        
        print_status "API documentation updated"
        echo "✅ API documentation updated" >> "$DOCS_LOG"
    else
        print_warning "No API endpoints found"
        echo "⚠️ No API endpoints found" >> "$DOCS_LOG"
    fi
else
    print_warning "Backend server.js not found"
    echo "⚠️ Backend server.js not found" >> "$DOCS_LOG"
fi

print_section "5. VERSION TRACKING"
echo "" >> "$DOCS_LOG"
echo "5. VERSION TRACKING" >> "$DOCS_LOG"

# Version tracking
print_subsection "Tracking versions..."
echo "Tracking versions..." >> "$DOCS_LOG"

# Get current versions
IOS_VERSION=$(grep -E "MARKETING_VERSION|CURRENT_PROJECT_VERSION" SupportingFiles/StryVr.xcodeproj/project.pbxproj 2>/dev/null | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "Unknown")
NODE_VERSION=$(node --version 2>/dev/null || echo "Unknown")
NPM_VERSION=$(npm --version 2>/dev/null || echo "Unknown")

print_info "iOS Version: $IOS_VERSION"
print_info "Node.js Version: $NODE_VERSION"
print_info "NPM Version: $NPM_VERSION"

echo "iOS Version: $IOS_VERSION" >> "$DOCS_LOG"
echo "Node.js Version: $NODE_VERSION" >> "$DOCS_LOG"
echo "NPM Version: $NPM_VERSION" >> "$DOCS_LOG"

# Create version tracking file
cat > Docs/VERSION_TRACKING.md << EOF
# Version Tracking - $CURRENT_DATE

## Current Versions

- **iOS App**: $IOS_VERSION
- **Node.js**: $NODE_VERSION
- **NPM**: $NPM_VERSION
- **Swift**: 6.1.2
- **Xcode**: 16.0+

## Version History

### $CURRENT_DATE
- Documentation agent created
- Version tracking implemented
- API documentation updated

## Next Release
- Target version: [Next version]
- Planned features: [List features]
- Release date: [Target date]

EOF

print_status "Version tracking created"
echo "✅ Version tracking created" >> "$DOCS_LOG"

print_section "6. DOCUMENTATION SYNC"
echo "" >> "$DOCS_LOG"
echo "6. DOCUMENTATION SYNC" >> "$DOCS_LOG"

# Sync documentation across platforms
print_subsection "Syncing documentation..."
echo "Syncing documentation..." >> "$DOCS_LOG"

# Check for documentation consistency
DOCS_CONSISTENCY_ISSUES=0

# Check if all documentation files have proper headers
for file in README.md CONTRIBUTING.md LICENSE CONTACT.md; do
    if [ -f "$file" ]; then
        if ! head -1 "$file" | grep -q "^#"; then
            print_warning "⚠️ $file missing proper header"
            echo "⚠️ $file missing proper header" >> "$DOCS_LOG"
            ((DOCS_CONSISTENCY_ISSUES++))
        else
            print_status "✅ $file has proper header"
            echo "✅ $file has proper header" >> "$DOCS_LOG"
        fi
    fi
done

if [ "$DOCS_CONSISTENCY_ISSUES" -eq 0 ]; then
    print_status "All documentation files are consistent"
    echo "✅ All documentation files are consistent" >> "$DOCS_LOG"
else
    print_warning "Documentation consistency issues: $DOCS_CONSISTENCY_ISSUES"
    echo "⚠️ Documentation consistency issues: $DOCS_CONSISTENCY_ISSUES" >> "$DOCS_LOG"
fi

print_section "7. DOCUMENTATION AUTOMATION"
echo "" >> "$DOCS_LOG"
echo "7. DOCUMENTATION AUTOMATION" >> "$DOCS_LOG"

# Create documentation automation scripts
print_subsection "Creating documentation automation..."
echo "Creating documentation automation..." >> "$DOCS_LOG"

# Create auto-documentation script
cat > Scripts/auto_document.sh << 'EOF'
#!/bin/bash
# Auto-documentation script

echo "📚 Auto-generating documentation..."

# Update README.md with current status
echo "Updating README.md..."

# Get current git status
GIT_STATUS=$(git status --porcelain | wc -l)
if [ "$GIT_STATUS" -eq 0 ]; then
    REPO_STATUS="Clean"
else
    REPO_STATUS="Dirty ($GIT_STATUS changes)"
fi

# Update README.md with current status
sed -i '' "s/Status.*$/Status: $REPO_STATUS/" README.md 2>/dev/null

echo "✅ Documentation updated"
EOF

chmod +x Scripts/auto_document.sh
print_status "Auto-documentation script created"

# Create documentation validation script
cat > Scripts/validate_docs.sh << 'EOF'
#!/bin/bash
# Documentation validation script

echo "🔍 Validating documentation..."

# Check for broken links
echo "Checking for broken links..."
BROKEN_LINKS=$(find . -name "*.md" -exec grep -l "\[.*\](.*)" {} \; | xargs grep -o "\[.*\](.*)" | grep -v "http" | wc -l)

if [ "$BROKEN_LINKS" -eq 0 ]; then
    echo "✅ No broken links found"
else
    echo "⚠️ Found $BROKEN_LINKS potential broken links"
fi

# Check for missing documentation
echo "Checking for missing documentation..."
MISSING_DOCS=0

for dir in StryVr/Views StryVr/Models StryVr/Services; do
    if [ -d "$dir" ]; then
        SWIFT_FILES=$(find "$dir" -name "*.swift" | wc -l)
        DOC_FILES=$(find "$dir" -name "*.md" | wc -l)
        if [ "$DOC_FILES" -eq 0 ] && [ "$SWIFT_FILES" -gt 0 ]; then
            echo "⚠️ $dir has Swift files but no documentation"
            ((MISSING_DOCS++))
        fi
    fi
done

if [ "$MISSING_DOCS" -eq 0 ]; then
    echo "✅ All directories have appropriate documentation"
else
    echo "⚠️ $MISSING_DOCS directories need documentation"
fi

echo "✅ Documentation validation completed"
EOF

chmod +x Scripts/validate_docs.sh
print_status "Documentation validation script created"

print_section "8. DOCUMENTATION RECOMMENDATIONS"
echo "" >> "$DOCS_LOG"
echo "8. DOCUMENTATION RECOMMENDATIONS" >> "$DOCS_LOG"

print_subsection "Documentation recommendations..."
echo "Documentation recommendations..." >> "$DOCS_LOG"

echo "1. Set up automated documentation generation" >> "$DOCS_LOG"
echo "2. Implement documentation testing" >> "$DOCS_LOG"
echo "3. Set up documentation versioning" >> "$DOCS_LOG"
echo "4. Create documentation templates" >> "$DOCS_LOG"
echo "5. Set up documentation review process" >> "$DOCS_LOG"

print_info "Documentation recommendations:"
echo "1. Set up automated documentation generation"
echo "2. Implement documentation testing"
echo "3. Set up documentation versioning"
echo "4. Create documentation templates"
echo "5. Set up documentation review process"

print_section "9. SUMMARY & NEXT STEPS"
echo "" >> "$DOCS_LOG"
echo "9. SUMMARY & NEXT STEPS" >> "$DOCS_LOG"

print_status "Documentation agent completed!"
echo "✅ Documentation agent completed!" >> "$DOCS_LOG"

print_info "📋 Documentation action items:"
echo "📋 Documentation action items:" >> "$DOCS_LOG"
echo "1. Auto-document: ./Scripts/auto_document.sh" >> "$DOCS_LOG"
echo "2. Validate docs: ./Scripts/validate_docs.sh" >> "$DOCS_LOG"
echo "3. Review generated changelog" >> "$DOCS_LOG"
echo "4. Update API documentation" >> "$DOCS_LOG"
echo "5. Set up automated documentation" >> "$DOCS_LOG"

print_info "📊 Documentation report saved to: $DOCS_LOG"
echo "📊 Documentation report saved to: $DOCS_LOG" >> "$DOCS_LOG"

echo ""
print_warning "💡 Documentation Pro Tips:"
echo "   - Keep documentation up to date with code changes"
echo "   - Use consistent formatting across all docs"
echo "   - Include examples and code snippets"
echo "   - Review documentation regularly"
echo "   - Set up automated documentation generation"

echo ""
print_status "🎉 Documentation agent completed successfully!"
echo ""
echo "📞 Need help? Contact: upflowapp@gmail.com" 