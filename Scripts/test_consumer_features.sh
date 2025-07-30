#!/bin/bash
# Test consumer features and user experience

echo "🧪 Testing consumer features..."

# Test onboarding flow
echo "Testing onboarding flow..."
if [ -d "StryVr/Views/Onboarding" ]; then
    echo "✅ Onboarding views available"
else
    echo "❌ Onboarding views not found"
fi

# Test gamification features
echo "Testing gamification features..."
if [ -f "StryVr/Views/LeaderboardView.swift" ]; then
    echo "✅ Leaderboard feature available"
else
    echo "❌ Leaderboard feature not found"
fi

if [ -f "StryVr/Services/ChallengeSystem.swift" ]; then
    echo "✅ Challenge system available"
else
    echo "❌ Challenge system not found"
fi

# Test personalization features
echo "Testing personalization features..."
if [ -f "StryVr/Services/AIRecommendationService.swift" ]; then
    echo "✅ AI recommendations available"
else
    echo "❌ AI recommendations not found"
fi

# Test accessibility features
echo "Testing accessibility features..."
ACCESSIBILITY_COUNT=$(grep -r "accessibility" StryVr/ 2>/dev/null | wc -l)
echo "Accessibility features found: $ACCESSIBILITY_COUNT"
