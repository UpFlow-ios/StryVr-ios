#!/bin/bash

# ✅ STEP 1: Define variables
SCHEME="StryVr"
PROJECT_PATH="./SupportingFiles/StryVr.xcodeproj"
CONFIGURATION="Release"
ARCHIVE_PATH="./build/StryVr.xcarchive"
TOOLCHAIN_PATH="$HOME/Library/Developer/Toolchains/swift-6.1.2.xctoolchain"

# ✅ STEP 2: Clean build
echo "🧹 Cleaning previous build..."
xcodebuild clean \
  -scheme "$SCHEME" \
  -project "$PROJECT_PATH"

# ✅ STEP 3: Build and Archive with Swift 6.1.2
echo "📦 Building and archiving with Swift 6.1.2..."
xcodebuild \
  -scheme "$SCHEME" \
  -project "$PROJECT_PATH" \
  -configuration "$CONFIGURATION" \
  -sdk iphoneos \
  -toolchain "$TOOLCHAIN_PATH" \
  -archivePath "$ARCHIVE_PATH" \
  archive | tee build.log

# ✅ STEP 4: Final result
if [ -d "$ARCHIVE_PATH" ]; then
  echo "✅ Archive completed successfully: $ARCHIVE_PATH"
else
  echo "❌ Archive failed. Check build.log for details."
fi


