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
