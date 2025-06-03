#!/bin/bash

echo "🛑 Shutting down all simulators..."
xcrun simctl shutdown all

echo "🧹 Erasing all simulator content..."
xcrun simctl erase all

echo "🚀 Booting iPhone 16 Pro..."
xcrun simctl boot 94A4508C-8794-4451-B138-4287CE75F936

echo "📱 Opening Simulator app..."
open -a Simulator

echo "💻 Launching Xcode and opening StryVr.xcodeproj..."
open ~/Documents/stryvr-ios/SupportingFiles/StryVr.xcodeproj

# Small delay to let Xcode open
sleep 10

echo "🛠️ Cleaning Xcode build folder..."
xcodebuild clean -project ~/Documents/stryvr-ios/SupportingFiles/StryVr.xcodeproj -scheme StryVr -configuration Debug

echo "✅ Ready! Now switch to Xcode, select iPhone 16 Pro, and hit ⌘R to run StryVr!"


