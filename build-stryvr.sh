#!/bin/bash

# StryVr Single Build Manager
# Ensures only one build runs at a time

BUILD_LOCK_FILE="/tmp/stryvr_build.lock"
BUILD_LOG_FILE="current-build.log"

# Check if build is already running
if [ -f "$BUILD_LOCK_FILE" ]; then
    echo "🚫 Build already in progress. PID: $(cat $BUILD_LOCK_FILE)"
    echo "   If this is incorrect, run: rm $BUILD_LOCK_FILE"
    exit 1
fi

# Create lock file
echo $$ > "$BUILD_LOCK_FILE"

echo "🔨 Starting StryVr build..."
echo "📝 Build log: $BUILD_LOG_FILE"
echo "🔒 Build lock: $BUILD_LOCK_FILE"

# Clean up function
trap 'rm -f "$BUILD_LOCK_FILE"; echo "✅ Build completed. Lock removed."' EXIT

# Run the build
xcodebuild -project SupportingFiles/StryVr.xcodeproj \
    -scheme StryVr \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.3.1' \
    build 2>&1 | tee "$BUILD_LOG_FILE"

BUILD_EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo "📊 Build completed with exit code: $BUILD_EXIT_CODE"

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed. Check $BUILD_LOG_FILE for details."
fi

exit $BUILD_EXIT_CODE


