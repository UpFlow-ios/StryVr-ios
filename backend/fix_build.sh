#!/bin/zsh

# 🌐 Start StryVr backend server
echo "🔁 Restarting backend server on port 3000..."
pkill -f "node server.js" 2>/dev/null
(cd ~/Documents/stryvr-ios/backend && nohup npm start > server.log 2>&1 &)

# 🛑 Shutdown & Erase Simulators
echo "🛑 Shutting down all simulators..."
xcrun simctl shutdown all
echo "🧹 Erasing all simulator content..."
xcrun simctl erase all

# 🚀 Boot iPhone 16 Pro Simulator
echo "🚀 Booting iPhone 16 Pro..."
xcrun simctl boot 944A508C-8794-4451-B138-4287CE75F936 2>/dev/null || echo "⚠️  Already booted or invalid ID"

# 📱 Open Simulator App
open -a Simulator

# 💻 Open Xcode Project
echo "💻 Opening Xcode..."
open ~/Documents/stryvr-ios/SupportingFiles/StryVr.xcodeproj

# 🛠️ Clean Xcode Build
sleep 10
echo "🧼 Cleaning Xcode build directory..."
xcodebuild clean -project ~/Documents/stryvr-ios/SupportingFiles/StryVr.xcodeproj -scheme StryVr -configuration Debug

# ✅ Done!
afplay /System/Library/Sounds/Ping.aiff
echo "✅ StryVr system is reset and ready!"

