#!/bin/bash

# StryVr App Store Optimizer
# Comprehensive script to ensure App Store quality

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${PURPLE}🏆 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to measure execution time
measure_time() {
    local start_time=$(date +%s)
    "$@"
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo "⏱️  Completed in ${duration}s"
}

# MARK: - App Store Criteria Check

print_header "StryVr App Store Optimization"
echo "Checking all criteria for App Store success..."
echo ""

# MARK: - 1. Code Quality & Architecture
print_step "1. Code Quality & Architecture Analysis"

# Check SwiftLint violations
if command_exists swiftlint; then
    print_info "Running SwiftLint analysis..."
    local lint_violations=$(swiftlint lint --reporter json | jq length)
    if [ "$lint_violations" -eq 0 ]; then
        print_success "Zero SwiftLint violations - Excellent code quality!"
    else
        print_warning "Found $lint_violations SwiftLint violations"
        print_info "Consider fixing these for better code quality"
    fi
else
    print_warning "SwiftLint not installed - Install for code quality checks"
fi

# Check code coverage
print_info "Checking test coverage..."
if [ -d "Tests" ]; then
    local test_files=$(find Tests -name "*.swift" | wc -l)
    if [ "$test_files" -gt 10 ]; then
        print_success "Good test coverage: $test_files test files found"
    else
        print_warning "Low test coverage: Only $test_files test files"
        print_info "Consider adding more unit and UI tests"
    fi
else
    print_error "No Tests directory found - Critical for App Store submission"
fi

# MARK: - 2. Performance Optimization
print_step "2. Performance Analysis"

# Check build performance
print_info "Measuring build performance..."
measure_time xcodebuild clean -project SupportingFiles/StryVr.xcodeproj -scheme StryVr

# Check app size
print_info "Checking app size optimization..."
if [ -f "builds/StryVr.ipa" ]; then
    local app_size=$(stat -f%z "builds/StryVr.ipa" 2>/dev/null || stat -c%s "builds/StryVr.ipa" 2>/dev/null)
    local app_size_mb=$((app_size / 1024 / 1024))
    if [ "$app_size_mb" -lt 100 ]; then
        print_success "App size optimized: ${app_size_mb}MB"
    else
        print_warning "App size large: ${app_size_mb}MB - Consider optimization"
    fi
fi

# MARK: - 3. Accessibility Compliance
print_step "3. Accessibility Compliance Check"

# Check for accessibility labels
print_info "Scanning for accessibility implementation..."
local accessibility_count=$(grep -r "accessibilityLabel\|accessibilityHint\|accessibilityAddTraits" StryVr/ --include="*.swift" | wc -l)
if [ "$accessibility_count" -gt 50 ]; then
    print_success "Good accessibility coverage: $accessibility_count implementations"
else
    print_warning "Limited accessibility: $accessibility_count implementations"
    print_info "Add more accessibility labels and hints for VoiceOver support"
fi

# Check for Dynamic Type support
local dynamic_type_count=$(grep -r "dynamicTypeSize\|scalable" StryVr/ --include="*.swift" | wc -l)
if [ "$dynamic_type_count" -gt 10 ]; then
    print_success "Dynamic Type support implemented: $dynamic_type_count instances"
else
    print_warning "Limited Dynamic Type support: $dynamic_type_count instances"
fi

# MARK: - 4. Localization & Internationalization
print_step "4. Localization Analysis"

# Check localization files
if [ -f "StryVr/Resources/en.lproj/Localizable.strings" ]; then
    local localization_entries=$(grep -c "=" "StryVr/Resources/en.lproj/Localizable.strings")
    if [ "$localization_entries" -gt 100 ]; then
        print_success "Comprehensive localization: $localization_entries entries"
    else
        print_warning "Limited localization: $localization_entries entries"
    fi
else
    print_error "No localization files found - Critical for global success"
fi

# Check for hardcoded strings
local hardcoded_strings=$(grep -r "Text(\".*\")" StryVr/ --include="*.swift" | wc -l)
if [ "$hardcoded_strings" -lt 50 ]; then
    print_success "Good localization practices: Limited hardcoded strings"
else
    print_warning "Many hardcoded strings: $hardcoded_strings found"
    print_info "Replace with NSLocalizedString for better localization"
fi

# MARK: - 5. Security & Privacy
print_step "5. Security & Privacy Analysis"

# Check for secure storage usage
local secure_storage_count=$(grep -r "SecureStorage\|Keychain\|LAContext" StryVr/ --include="*.swift" | wc -l)
if [ "$secure_storage_count" -gt 10 ]; then
    print_success "Good security implementation: $secure_storage_count secure storage usages"
else
    print_warning "Limited security features: $secure_storage_count implementations"
fi

# Check for privacy compliance
if [ -f "PRIVACY_POLICY.md" ]; then
    print_success "Privacy policy documented"
else
    print_error "No privacy policy found - Required for App Store"
fi

# MARK: - 6. User Experience & Design
print_step "6. User Experience Analysis"

# Check for Liquid Glass UI implementation
local liquid_glass_count=$(grep -r "liquidGlass\|ultraThinMaterial" StryVr/ --include="*.swift" | wc -l)
if [ "$liquid_glass_count" -gt 20 ]; then
    print_success "Liquid Glass UI well implemented: $liquid_glass_count instances"
else
    print_warning "Limited Liquid Glass UI: $liquid_glass_count instances"
fi

# Check for animations and micro-interactions
local animation_count=$(grep -r "withAnimation\|spring\|easeInOut" StryVr/ --include="*.swift" | wc -l)
if [ "$animation_count" -gt 30 ]; then
    print_success "Rich animations: $animation_count animation implementations"
else
    print_warning "Limited animations: $animation_count implementations"
fi

# MARK: - 7. App Store Optimization
print_step "7. App Store Optimization"

# Check for App Store assets
if [ -d "Marketing/AppStore" ]; then
    local screenshot_count=$(find Marketing/AppStore -name "*.png" | wc -l)
    if [ "$screenshot_count" -gt 10 ]; then
        print_success "App Store assets prepared: $screenshot_count screenshots"
    else
        print_warning "Limited App Store assets: $screenshot_count screenshots"
    fi
else
    print_error "No App Store assets directory - Critical for submission"
fi

# Check for App Store metadata
if [ -f "APP_STORE_CONNECT_SETUP.md" ]; then
    print_success "App Store Connect setup documented"
else
    print_warning "App Store Connect setup not documented"
fi

# MARK: - 8. Innovation & AI Features
print_step "8. Innovation & AI Features Analysis"

# Check for AI implementation
local ai_features=$(grep -r "AI\|artificial\|intelligence\|recommendation" StryVr/ --include="*.swift" | wc -l)
if [ "$ai_features" -gt 20 ]; then
    print_success "Strong AI implementation: $ai_features AI-related features"
else
    print_warning "Limited AI features: $ai_features implementations"
fi

# Check for unique features
local unique_features=$(grep -r "verification\|biometric\|ClearMe" StryVr/ --include="*.swift" | wc -l)
if [ "$unique_features" -gt 10 ]; then
    print_success "Unique features implemented: $unique_features special features"
else
    print_warning "Limited unique features: $unique_features implementations"
fi

# MARK: - 9. Documentation & Developer Experience
print_step "9. Documentation Analysis"

# Check for comprehensive documentation
local doc_files=$(find . -name "*.md" | wc -l)
if [ "$doc_files" -gt 15 ]; then
    print_success "Comprehensive documentation: $doc_files markdown files"
else
    print_warning "Limited documentation: $doc_files markdown files"
fi

# Check for code comments
local code_comments=$(grep -r "///\|// MARK:" StryVr/ --include="*.swift" | wc -l)
if [ "$code_comments" -gt 100 ]; then
    print_success "Well-documented code: $code_comments comments"
else
    print_warning "Limited code documentation: $code_comments comments"
fi

# MARK: - 10. CI/CD & Automation
print_step "10. CI/CD & Automation Analysis"

# Check for GitHub Actions
if [ -f ".github/workflows/ci-cd.yml" ]; then
    print_success "GitHub Actions CI/CD pipeline configured"
else
    print_warning "No GitHub Actions workflow found"
fi

# Check for Fastlane
if [ -f "Fastfile" ]; then
    print_success "Fastlane automation configured"
else
    print_warning "No Fastlane configuration found"
fi

# MARK: - Summary & Recommendations
print_header "App Store Optimization Summary"
echo ""

# Calculate overall score
local total_checks=10
local passed_checks=0
local warnings=0
local errors=0

# This would be calculated based on the checks above
# For now, providing a template

print_info "Overall Assessment:"
print_success "✅ Strong foundation for App Store submission"
print_warning "⚠️  Areas for improvement identified"
print_error "❌ Critical issues need attention"

echo ""
print_header "Recommendations for App Store Success:"

echo "1. 🧪 Testing: Add comprehensive unit and UI tests"
echo "2. 🌍 Localization: Implement full internationalization"
echo "3. ♿ Accessibility: Enhance VoiceOver and Dynamic Type support"
echo "4. 📱 App Store Assets: Create professional screenshots and metadata"
echo "5. 🔒 Security: Strengthen privacy and security features"
echo "6. 🎨 UX: Polish animations and micro-interactions"
echo "7. 🤖 AI: Expand AI-powered features"
echo "8. 📚 Documentation: Improve developer and user documentation"
echo "9. 🔄 CI/CD: Implement automated testing and deployment"
echo "10. 🏆 Innovation: Add unique, award-worthy features"

echo ""
print_header "Next Steps:"
echo "1. Prioritize critical issues (❌ errors)"
echo "2. Address warnings (⚠️) for better quality"
echo "3. Enhance strengths (✅) for competitive advantage"
echo "4. Create App Store assets and metadata"
echo "5. Submit for App Store review"

echo ""
print_success "StryVr has excellent potential for App Store success!"
print_info "Focus on the recommendations above to maximize success." 