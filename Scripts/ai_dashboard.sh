#!/bin/bash
# AI Service Dashboard

echo "📊 AI Service Dashboard"
echo "======================"

# API Status
echo "🔌 API Status:"
if [ -f "backend/.env" ]; then
    source backend/.env
    [ -n "$HUGGINGFACE_API_KEY" ] && echo "  ✅ HuggingFace API: Configured" || echo "  ❌ HuggingFace API: Not configured"
    [ -n "$OPENAI_API_KEY" ] && echo "  ✅ OpenAI API: Configured" || echo "  ❌ OpenAI API: Not configured"
else
    echo "  ❌ Environment file not found"
fi

# Service Status
echo ""
echo "🤖 AI Services:"
[ -f "StryVr/Services/AIRecommendationService.swift" ] && echo "  ✅ AI Recommendation Service" || echo "  ❌ AI Recommendation Service"
[ -f "StryVr/Services/AIProfileValidator.swift" ] && echo "  ✅ AI Profile Validator" || echo "  ❌ AI Profile Validator"
[ -f "StryVr/Services/AIGreetingManager.swift" ] && echo "  ✅ AI Greeting Manager" || echo "  ❌ AI Greeting Manager"

# Performance Metrics
echo ""
echo "📈 Performance Metrics:"
echo "  AI Files: $(find StryVr -name "*.swift" -exec grep -l -i "ai" {} \; 2>/dev/null | wc -l)"
echo "  Async Patterns: $(grep -r "async\|await" StryVr/Services/ 2>/dev/null | wc -l)"
echo "  Error Handling: $(grep -r "catch\|error" StryVr/Services/ 2>/dev/null | wc -l)"
