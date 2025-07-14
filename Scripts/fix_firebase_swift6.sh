#!/bin/bash

# 🔥 FirebaseStorage Swift 6 Header Generation Fix Script
# This script fixes the "SwiftMergeGeneratedHeaders FirebaseStorage-Swift.h" error

echo "🧹 Cleaning up FirebaseStorage Swift 6 header generation issues..."

# 1. Clean DerivedData
echo "📁 Cleaning DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/StryVr-*
rm -rf ~/Library/Developer/Xcode/DerivedData/Firebase*

# 2. Clean build folder
echo "🏗️ Cleaning build folder..."
rm -rf build/
rm -rf *.xcarchive

# 3. Clean Pods if using CocoaPods
if [ -d "Pods" ]; then
    echo "📦 Cleaning Pods..."
    rm -rf Pods/
    rm -rf Podfile.lock
fi

# 4. Clean Swift Package Manager cache
echo "📦 Cleaning Swift Package Manager cache..."
rm -rf ~/Library/Caches/org.swift.swiftpm/
rm -rf .build/

# 5. Reset Xcode state
echo "🔄 Resetting Xcode state..."
defaults delete com.apple.dt.Xcode
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks 8

# 6. Clean Firebase specific caches
echo "🔥 Cleaning Firebase caches..."
rm -rf ~/Library/Caches/Firebase/
rm -rf ~/Library/Application\ Support/Firebase/

echo "✅ FirebaseStorage Swift 6 cleanup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Open Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Build (Cmd+B)"
echo "4. If issues persist, check:"
echo "   - SWIFT_EMIT_LOC_STRINGS = NO"
echo "   - SWIFT_SUPPRESS_WARNINGS = YES"
echo "   - SWIFT_VERSION = 6.0"
echo "   - No @objc usage in FirebaseStorage code" 