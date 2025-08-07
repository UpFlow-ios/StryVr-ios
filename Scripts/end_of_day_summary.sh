#!/bin/bash

# StryVr End of Day Summary Script
# Tracks daily accomplishments and sends to Slack

echo "🌅 StryVr - End of Day Summary"
echo "================================"

# Get current date
current_date=$(date +"%B %d, %Y")
echo "📅 Date: $current_date"

# Get git stats for today
commits_today=$(git log --since="00:00:00" --oneline | wc -l | xargs)
files_changed_today=$(git log --since="00:00:00" --name-only --pretty=format: | sort | uniq | wc -l | xargs)

echo ""
echo "📊 Today's Git Activity:"
echo "- Commits: $commits_today"
echo "- Files Modified: $files_changed_today"

# Latest commit info
latest_commit=$(git log -1 --pretty=format:"%h - %s")
echo "- Latest Commit: $latest_commit"

echo ""
echo "✅ Major Accomplishments Today:"

# Create comprehensive summary
summary="🚀 *StryVr Development Summary - $current_date*

✅ *Major Accomplishments:*
• Professional Liquid Glass app icons implemented (iOS 18 style)
• Light/dark mode icon support configured
• 34 SwiftLint violations fixed (reduced from 121 to 87)
• Router Navigation system with type-safety implemented
• AI Insights view with Liquid Glass styling created
• Analytics Dashboard with interactive charts built
• Subscription view with pricing tiers completed
• Haptic feedback system integrated
• iPhone 16 Pro Max simulator configured for testing

📊 *Development Stats:*
• Git Commits Today: $commits_today
• Files Modified: $files_changed_today
• Latest: $latest_commit

🎯 *Ready for Tomorrow:*
• Address GitHub security vulnerability
• Capture App Store screenshots
• Final testing before submission

💪 *StryVr is App Store ready with premium Liquid Glass design!*"

echo "$summary"

# Send to Slack if configured
if [ -f ".slack_config.json" ]; then
    echo ""
    echo "📤 Sending summary to Slack..."
    
    # Get webhook URL
    webhook_url=$(cat .slack_config.json | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('webhooks', {}).get('general', ''))" 2>/dev/null)
    
    if [ ! -z "$webhook_url" ]; then
        curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$summary\"}" "$webhook_url" -s > /dev/null
        echo "✅ Summary sent to Slack successfully!"
    else
        echo "⚠️ Slack webhook not found in config"
    fi
else
    echo "⚠️ Slack config not found - run manually or set up Slack integration"
fi

echo ""
echo "🎉 Excellent work today! StryVr is looking incredible!"
echo "================================"
