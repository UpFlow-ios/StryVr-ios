#!/bin/bash

# StryVr Daily Maintenance Script
echo "🔧 StryVr Daily Maintenance - $(date +'%B %d, %Y')"
echo "================================================"

# 1. Git Health Check
echo "📊 Git Repository Status:"
git_status=$(git status --porcelain)
if [ -z "$git_status" ]; then
    echo "✅ Repository clean"
else
    echo "⚠️ Uncommitted changes found"
fi

# 2. SwiftLint Code Quality
echo ""
echo "🔍 Code Quality Check:"
if command -v swiftlint >/dev/null 2>&1; then
    violations=$(swiftlint 2>&1 | grep -c "warning\|error" || echo "0")
    if [ "$violations" -eq 0 ]; then
        echo "✅ No SwiftLint violations"
        quality="🟢 Excellent"
    elif [ "$violations" -le 10 ]; then
        echo "⚠️ $violations violations found"
        quality="🟡 Good ($violations issues)"
    else
        echo "❌ $violations violations - needs work"
        quality="🔴 Poor ($violations issues)"
    fi
else
    echo "⚠️ SwiftLint not installed"
    quality="❓ Unknown"
fi

# 3. Build Test
echo ""
echo "🏗️ Build Health:"
if xcodebuild build -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -quiet >/dev/null 2>&1; then
    echo "✅ Build successful"
    build_status="🟢 Success"
else
    echo "❌ Build failed"
    build_status="🔴 Failed"
fi

# 4. App Store Readiness
echo ""
echo "🏪 App Store Readiness:"
score=0
total=3

# Check app icons
if [ -f "StryVr/Assets.xcassets/AppIcon.appiconset/AppIcon-Light-1x.png" ]; then
    echo "✅ App icons present"
    score=$((score + 1))
else
    echo "❌ App icons missing"
fi

# Check Info.plist
if [ -f "StryVr/Info.plist" ]; then
    echo "✅ Info.plist configured"
    score=$((score + 1))
else
    echo "❌ Info.plist missing"
fi

# Check code quality
if [ "$violations" -le 20 ]; then
    echo "✅ Code quality acceptable"
    score=$((score + 1))
else
    echo "⚠️ Code quality needs improvement"
fi

readiness=$((score * 100 / total))

# 5. Overall Status
echo ""
echo "📋 Summary:"
echo "Code Quality: $quality"
echo "Build Status: $build_status"
echo "App Store Ready: $score/$total ($readiness%)"

if [ "$build_status" = "🟢 Success" ] && [ "$violations" -le 5 ]; then
    overall="🟢 Excellent"
    emoji="🚀"
elif [ "$build_status" = "🟢 Success" ]; then
    overall="🟡 Good"
    emoji="👍"
else
    overall="🔴 Needs Work"
    emoji="⚠️"
fi

echo ""
echo "$emoji StryVr Health: $overall"

# 6. Send to Slack
if [ -f "~/.stryvr/secure/.slack_config.json" ]; then
    webhook=$(cat ~/.stryvr/secure/.slack_config.json | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['webhooks']['dev'])" 2>/dev/null)
    if [ ! -z "$webhook" ]; then
        curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"🔧 *Daily Maintenance Complete*\n\n• Code Quality: $quality\n• Build: $build_status\n• App Store Ready: $readiness%\n\n$emoji *Overall: $overall*\"}" "$webhook" -s >/dev/null
        echo "📤 Report sent to Slack"
    fi
fi

echo ""
echo "🎉 Maintenance complete!"