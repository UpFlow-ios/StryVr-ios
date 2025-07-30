#!/bin/bash

# 📱 iOS Build Optimizer for StryVr
# This script optimizes Xcode builds, cleans caches, and resolves common iOS build issues

echo "📱 Running iOS build optimization for StryVr..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

# Check if we're in the right directory
if [ ! -d "SupportingFiles" ]; then
    print_error "Xcode project not found. Please run this script from the project root."
    exit 1
fi

print_section "1. XCODE CACHE CLEANUP"

# Kill Xcode processes
print_info "Stopping Xcode processes..."
pkill -f "Xcode" 2>/dev/null || print_info "No Xcode processes running"

# Clean DerivedData
print_info "Cleaning DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*
print_status "DerivedData cleaned"

# Clean ModuleCache
print_info "Cleaning ModuleCache..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/*
print_status "ModuleCache cleaned"

# Clean Swift Package Manager caches
print_info "Cleaning Swift Package Manager caches..."
rm -rf ~/Library/Caches/org.swift.swiftpm/
print_status "Swift Package Manager caches cleaned"

print_section "2. PROJECT CLEANUP"

# Clean build folder
print_info "Cleaning project build folder..."
if [ -d "SupportingFiles/build" ]; then
    rm -rf SupportingFiles/build
    print_status "Build folder cleaned"
fi

# Clean .xcuserdata
print_info "Cleaning Xcode user data..."
find . -name "*.xcuserdata" -type d -exec rm -rf {} + 2>/dev/null
print_status "Xcode user data cleaned"

# Clean .xcworkspace/xcuserdata
print_info "Cleaning workspace user data..."
find . -name "xcuserdata" -type d -exec rm -rf {} + 2>/dev/null
print_status "Workspace user data cleaned"

print_section "3. SWIFT PACKAGE MANAGER OPTIMIZATION"

# Check Swift Package Manager dependencies
print_info "Checking Swift Package Manager dependencies..."
if [ -d "SupportingFiles/StryVr.xcodeproj/project.xcworkspace/xcshareddata/swiftpm" ]; then
    print_info "Swift Package Manager dependencies found"
    
    # List current packages
    print_info "Current Swift packages:"
    find SupportingFiles/StryVr.xcodeproj/project.xcworkspace/xcshareddata/swiftpm -name "Package.resolved" -exec cat {} \; 2>/dev/null | grep -E "(package|version)" || print_warning "No Package.resolved found"
else
    print_warning "No Swift Package Manager dependencies found"
fi

print_section "4. BUILD CONFIGURATION CHECK"

# Check for common build issues
print_info "Checking for common build issues..."

# Check for missing files in project
print_info "Checking for missing files in project..."
MISSING_FILES=$(find StryVr -name "*.swift" -exec basename {} \; | while read file; do
    if ! grep -q "$file" SupportingFiles/StryVr.xcodeproj/project.pbxproj 2>/dev/null; then
        echo "$file"
    fi
done)

if [ -n "$MISSING_FILES" ]; then
    print_warning "Potentially missing files from project:"
    echo "$MISSING_FILES"
else
    print_status "All Swift files appear to be in project"
fi

# Check for duplicate files
print_info "Checking for duplicate file references..."
DUPLICATES=$(grep -o '"[^"]*\.swift"' SupportingFiles/StryVr.xcodeproj/project.pbxproj | sort | uniq -d)
if [ -n "$DUPLICATES" ]; then
    print_warning "Duplicate file references found:"
    echo "$DUPLICATES"
else
    print_status "No duplicate file references found"
fi

print_section "5. PERFORMANCE OPTIMIZATION"

# Check system resources
print_info "Checking system resources..."
MEMORY_USAGE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
MEMORY_GB=$((MEMORY_USAGE * 4096 / 1024 / 1024 / 1024))
print_info "Available memory: ${MEMORY_GB}GB"

DISK_SPACE=$(df -h . | tail -1 | awk '{print $4}')
print_info "Available disk space: $DISK_SPACE"

# Optimize Xcode settings
print_info "Optimizing Xcode settings..."
defaults write com.apple.dt.Xcode BuildSystemSchedulingPolicy -string "0" 2>/dev/null
defaults write com.apple.dt.Xcode BuildSystemScheduleInherentlyParallelCommandsExclusively -bool NO 2>/dev/null
print_status "Xcode build system optimized"

print_section "6. BUILD TESTING"

# Test build process
print_info "Testing build process..."
print_warning "Manual build test required:"
echo "1. Open SupportingFiles/StryVr.xcodeproj"
echo "2. Select target device/simulator"
echo "3. Press Cmd+Shift+K to clean build folder"
echo "4. Press Cmd+B to build project"
echo "5. Press Cmd+R to run on simulator"

print_section "7. COMMON ISSUE RESOLUTION"

# Check for specific StryVr issues
print_info "Checking for StryVr-specific issues..."

# Check Firebase configuration
if [ -f "backend/GoogleService-Info.plist" ]; then
    print_status "Firebase configuration found"
else
    print_warning "Firebase configuration not found in backend/"
fi

# Check environment variables
if [ -f "backend/.env" ]; then
    print_status "Environment variables configured"
else
    print_warning "Environment variables not configured"
fi

# Check for large assets
print_info "Checking for large assets..."
find . -name "*.xcassets" -exec find {} -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \; | while read asset; do
    SIZE=$(stat -f%z "$asset" 2>/dev/null || echo "0")
    if [ "$SIZE" -gt 1048576 ]; then  # 1MB
        print_warning "Large asset found: $asset ($(($SIZE / 1024 / 1024))MB)"
    fi
done

print_section "8. OPTIMIZATION RECOMMENDATIONS"

print_info "Build optimization recommendations:"
echo "1. Use incremental builds when possible"
echo "2. Enable parallel builds in Xcode preferences"
echo "3. Use Swift Package Manager for dependencies"
echo "4. Optimize asset sizes (compress images)"
echo "5. Remove unused code and resources"
echo "6. Use appropriate deployment targets"
echo "7. Enable bitcode for App Store builds"
echo "8. Use appropriate optimization levels"

print_section "9. MONITORING SETUP"

# Create build monitoring script
print_info "Setting up build monitoring..."
cat > Scripts/monitor_build.sh << 'EOF'
#!/bin/bash
# Monitor build performance and report issues

echo "🔍 Monitoring build performance..."

# Check build time
START_TIME=$(date +%s)
xcodebuild -project SupportingFiles/StryVr.xcodeproj -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))

echo "Build completed in ${BUILD_TIME} seconds"

# Check for warnings and errors
WARNINGS=$(xcodebuild -project SupportingFiles/StryVr.xcodeproj -scheme StryVr build 2>&1 | grep -c "warning:")
ERRORS=$(xcodebuild -project SupportingFiles/StryVr.xcodeproj -scheme StryVr build 2>&1 | grep -c "error:")

echo "Warnings: $WARNINGS"
echo "Errors: $ERRORS"

# Generate report
echo "Build Report - $(date)" > build_report.txt
echo "Build Time: ${BUILD_TIME} seconds" >> build_report.txt
echo "Warnings: $WARNINGS" >> build_report.txt
echo "Errors: $ERRORS" >> build_report.txt
EOF

chmod +x Scripts/monitor_build.sh
print_status "Build monitoring script created"

print_section "10. SUMMARY"

print_status "iOS build optimization completed!"
print_info "Next steps:"
echo "1. Open Xcode and clean build folder (Cmd+Shift+K)"
echo "2. Build project (Cmd+B)"
echo "3. Test on simulator (Cmd+R)"
echo "4. Run build monitoring: ./Scripts/monitor_build.sh"

print_warning "💡 Pro Tips:"
echo "   - Run this script before major builds"
echo "   - Monitor build times and optimize slow areas"
echo "   - Keep dependencies updated"
echo "   - Use appropriate build configurations"

echo ""
print_status "🎉 iOS build optimization completed successfully!"
echo ""
echo "📞 Need help? Contact: joedormond@stryvr.app" 