#!/bin/bash

echo "🔧 Fixing FirebaseStorage SwiftMergeGeneratedHeaders Issue..."

# Clear derived data
echo "🧹 Clearing Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/StryVr-*

# Clear module cache
echo "🧹 Clearing module cache..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex

# Clear Swift package cache
echo "🧹 Clearing Swift package cache..."
rm -rf ~/Library/Caches/org.swift.swiftpm

# Update Swift version in project file
echo "📝 Updating Swift version to 6.0..."
sed -i '' 's/SWIFT_VERSION = 5.0;/SWIFT_VERSION = 6.0;/g' SupportingFiles/StryVr.xcodeproj/project.pbxproj

# Add Firebase-specific build settings
echo "⚙️ Adding Firebase-specific build settings..."

# Add to Debug configuration
sed -i '' '/SWIFT_VERSION = 6.0;/a\
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";\
				SWIFT_COMPILATION_MODE = singlefile;\
				CLANG_ENABLE_MODULE_DEBUGGING = NO;\
				DEFINES_MODULE = YES;' SupportingFiles/StryVr.xcodeproj/project.pbxproj

# Add to Release configuration
sed -i '' '/SWIFT_VERSION = 6.0;/a\
				SWIFT_COMPILATION_MODE = wholemodule;\
				CLANG_ENABLE_MODULE_DEBUGGING = NO;\
				DEFINES_MODULE = YES;' SupportingFiles/StryVr.xcodeproj/project.pbxproj

echo "✅ FirebaseStorage fix applied!"
echo "🚀 Ready to build with clean Swift 6.0 configuration" 