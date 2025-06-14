nano ~/Documents/stryvr-ios/backend/reset.sh
#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "🌐 Starting StryVr backend server..."
(cd "$SCRIPT_DIR" && npm start > "$SCRIPT_DIR/server.log" 2>&1 &)

# Boot Simulator
echo "🛑 Shutting down all simulators..."
xcrun simctl shutdown all
echo "🧹 Erasing all simulator content..."
xcrun simctl erase all
echo "🚀 Booting iPhone 16 Pro..."
xcrun simctl boot 944A508C-8794-4451-B138-4287CE75F936

# Open Simulator and Xcode
echo "📱 Opening Simulator app..."
open -a Simulator
echo "💻 Launching Xcode and opening StryVr.xcodeproj..."
open ~/Documents/stryvr-ios/SupportingFiles/StryVr.xcodeproj

# Optional: Wait before build clean
sleep 10

# Clean build
echo "🛠️ Cleaning Xcode build folder..."
xcodebuild clean -project ~/Documents/stryvr-ios/SupportingFiles/StryVr.xcodeproj -scheme StryVr -configuration Debug

# ✅ Notify when done
osascript -e 'display notification "StryVr environment is ready! ⌘R to run." with title "✅ StryVr Boot Complete" sound name "Glass"' || echo "✅ Done! (osascript failed silently)"
afplay /System/Library/Sounds/Glass.aiff &>/dev/null

echo "✅ Ready! StryVr is fully booted."











