#!/bin/bash

# StryVr Build Cache Fix Script
# This script fixes Xcode build cache issues and ensures clean builds

echo "🔧 Fixing Xcode Build Cache Issues..."
echo "====================================="

# Stop Xcode if it's running
echo "1️⃣ Stopping Xcode..."
pkill -f "Xcode" 2>/dev/null || echo "Xcode not running"

# Clear all Xcode caches
echo "2️⃣ Clearing Xcode caches..."
rm -rf ~/Library/Developer/Xcode/DerivedData/
rm -rf ~/Library/Caches/com.apple.dt.Xcode/
rm -rf ~/Library/Developer/Xcode/Archives/
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/

# Clear Swift Package Manager cache
echo "3️⃣ Clearing Swift Package Manager cache..."
rm -rf ~/Library/Caches/org.swift.swiftpm/
rm -rf ~/Library/Developer/Xcode/DerivedData/SourcePackages/

# Clear module cache
echo "4️⃣ Clearing module cache..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/

# Clear build artifacts
echo "5️⃣ Clearing build artifacts..."
rm -rf build/
rm -rf .build/
rm -rf *.xcarchive

# Reset Xcode preferences (optional - uncomment if needed)
# echo "6️⃣ Resetting Xcode preferences..."
# defaults delete com.apple.dt.Xcode 2>/dev/null || echo "No Xcode preferences to reset"

echo ""
echo "✅ Build cache cleared successfully!"
echo ""
echo "🎯 Next Steps:"
echo "1. Open Xcode"
echo "2. Let it re-index and resolve packages"
echo "3. Build the project (should work now)"
echo ""
echo "💡 If you still have issues:"
echo "- Restart Xcode completely"
echo "- Clean build folder (Cmd+Shift+K)"
echo "- Reset package caches (File → Packages → Reset Package Caches)"
echo ""
echo "🚀 Ready for clean build!" 