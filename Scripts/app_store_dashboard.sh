#!/bin/bash
# App Store Monitoring Dashboard

echo "📊 App Store Monitoring Dashboard"
echo "================================"

# Consumer Features Status
echo "👥 Consumer Features:"
[ -d "StryVr/Views/Onboarding" ] && echo "  ✅ Onboarding Flow" || echo "  ❌ Onboarding Flow"
[ -d "StryVr/Views/Profile" ] && echo "  ✅ User Profile" || echo "  ❌ User Profile"
[ -d "StryVr/Views/Challenges" ] && echo "  ✅ Challenges" || echo "  ❌ Challenges"
[ -d "StryVr/Views/Feed" ] && echo "  ✅ Social Feed" || echo "  ❌ Social Feed"

# Gamification Features
echo ""
echo "🎮 Gamification Features:"
[ -f "StryVr/Views/LeaderboardView.swift" ] && echo "  ✅ Leaderboard" || echo "  ❌ Leaderboard"
[ -f "StryVr/Services/ChallengeSystem.swift" ] && echo "  ✅ Challenge System" || echo "  ❌ Challenge System"
[ -d "StryVr/Views/UIComponents" ] && echo "  ✅ UI Components" || echo "  ❌ UI Components"

# Personalization Features
echo ""
echo "🎯 Personalization Features:"
[ -f "StryVr/Services/AIRecommendationService.swift" ] && echo "  ✅ AI Recommendations" || echo "  ❌ AI Recommendations"
[ -f "StryVr/Services/AIProfileValidator.swift" ] && echo "  ✅ AI Profile Validator" || echo "  ❌ AI Profile Validator"

# App Store Assets
echo ""
echo "📱 App Store Assets:"
[ -d "Marketing/Assets" ] && echo "  ✅ Marketing Assets" || echo "  ❌ Marketing Assets"
[ -f "Marketing/Assets/logo_creation_guide.md" ] && echo "  ✅ Logo Guide" || echo "  ❌ Logo Guide"

# Performance Metrics
echo ""
echo "📈 Performance Metrics:"
echo "  Consumer Files: $(find StryVr -name "*.swift" -exec grep -l -i "user\|personal\|individual" {} \; 2>/dev/null | wc -l)"
echo "  Gamification Patterns: $(grep -r -i "achievement\|badge\|streak\|challenge" StryVr/ 2>/dev/null | wc -l)"
echo "  Accessibility Features: $(grep -r -i "accessibility" StryVr/ 2>/dev/null | wc -l)"
