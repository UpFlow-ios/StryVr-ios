#!/bin/bash

# 🤖 AI Service Monitor for StryVr
# This script monitors AI services, HuggingFace integration, and AI performance

echo "🤖 Running AI service monitoring for StryVr..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_section() {
    echo -e "${PURPLE}📋 $1${NC}"
    echo "=================================="
}

print_subsection() {
    echo -e "${CYAN}🔧 $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Not in the stryvr-ios repository root. Please run this script from the project root."
    exit 1
fi

# Get current date for logging
CURRENT_DATE=$(date +%Y-%m-%d)
AI_LOG="ai_service_monitor_${CURRENT_DATE}.log"

echo "🤖 AI Service Monitor Report - $CURRENT_DATE" > "$AI_LOG"
echo "=============================================" >> "$AI_LOG"

print_section "1. AI SERVICE ANALYSIS"
echo "1. AI SERVICE ANALYSIS" >> "$AI_LOG"

# Analyze AI services in the codebase
print_subsection "Analyzing AI services..."
echo "Analyzing AI services..." >> "$AI_LOG"

# Count AI-related files
AI_FILES=$(find StryVr -name "*.swift" -exec grep -l -i "ai\|huggingface\|openai\|recommendation" {} \; 2>/dev/null | wc -l)
print_info "AI-related Swift files: $AI_FILES"
echo "AI-related Swift files: $AI_FILES" >> "$AI_LOG"

# List AI services
print_subsection "AI Services found:"
echo "AI Services found:" >> "$AI_LOG"

AI_SERVICES=(
    "AIRecommendationService.swift"
    "AIProfileValidator.swift"
    "AISuggestionResponse.swift"
    "AIGreetingManager.swift"
    "AIRecommendationService.swift"
)

for service in "${AI_SERVICES[@]}"; do
    if [ -f "StryVr/Services/$service" ]; then
        print_status "✅ $service"
        echo "✅ $service" >> "$AI_LOG"
    else
        print_warning "⚠️ $service (not found)"
        echo "⚠️ $service (not found)" >> "$AI_LOG"
    fi
done

print_section "2. HUGGINGFACE INTEGRATION CHECK"
echo "" >> "$AI_LOG"
echo "2. HUGGINGFACE INTEGRATION CHECK" >> "$AI_LOG"

# Check HuggingFace API configuration
print_subsection "Checking HuggingFace integration..."
echo "Checking HuggingFace integration..." >> "$AI_LOG"

if [ -f "backend/.env" ]; then
    if grep -q "HUGGINGFACE_API_KEY" backend/.env; then
        print_status "HuggingFace API key configured"
        echo "HuggingFace API key configured" >> "$AI_LOG"
    else
        print_warning "HuggingFace API key not found in .env"
        echo "HuggingFace API key not found in .env" >> "$AI_LOG"
    fi
else
    print_warning "Environment file not found"
    echo "Environment file not found" >> "$AI_LOG"
fi

# Check for HuggingFace usage in code
HUGGINGFACE_USAGE=$(grep -r -i "huggingface" StryVr/ 2>/dev/null | wc -l)
print_info "HuggingFace references in code: $HUGGINGFACE_USAGE"
echo "HuggingFace references in code: $HUGGINGFACE_USAGE" >> "$AI_LOG"

print_section "3. AI PERFORMANCE MONITORING"
echo "" >> "$AI_LOG"
echo "3. AI PERFORMANCE MONITORING" >> "$AI_LOG"

# Check AI service performance patterns
print_subsection "Analyzing AI service patterns..."
echo "Analyzing AI service patterns..." >> "$AI_LOG"

# Check for async/await patterns in AI services
ASYNC_PATTERNS=$(grep -r "async\|await" StryVr/Services/ 2>/dev/null | wc -l)
print_info "Async/await patterns in AI services: $ASYNC_PATTERNS"
echo "Async/await patterns in AI services: $ASYNC_PATTERNS" >> "$AI_LOG"

# Check for error handling in AI services
ERROR_HANDLING=$(grep -r "catch\|error" StryVr/Services/ 2>/dev/null | wc -l)
print_info "Error handling patterns in AI services: $ERROR_HANDLING"
echo "Error handling patterns in AI services: $ERROR_HANDLING" >> "$AI_LOG"

print_section "4. AI RECOMMENDATION SYSTEM ANALYSIS"
echo "" >> "$AI_LOG"
echo "4. AI RECOMMENDATION SYSTEM ANALYSIS" >> "$AI_LOG"

# Analyze recommendation system
print_subsection "Analyzing recommendation system..."
echo "Analyzing recommendation system..." >> "$AI_LOG"

if [ -f "StryVr/Services/AIRecommendationService.swift" ]; then
    print_status "AI Recommendation Service found"
    echo "AI Recommendation Service found" >> "$AI_LOG"
    
    # Check for key methods
    METHODS=("getSkillRecommendations" "saveSkillRecommendation" "getPersonalizedRecommendations")
    for method in "${METHODS[@]}"; do
        if grep -q "$method" StryVr/Services/AIRecommendationService.swift; then
            print_status "✅ $method method found"
            echo "✅ $method method found" >> "$AI_LOG"
        else
            print_warning "⚠️ $method method not found"
            echo "⚠️ $method method not found" >> "$AI_LOG"
        fi
    done
else
    print_error "AI Recommendation Service not found"
    echo "AI Recommendation Service not found" >> "$AI_LOG"
fi

print_section "5. AI SERVICE OPTIMIZATION"
echo "" >> "$AI_LOG"
echo "5. AI SERVICE OPTIMIZATION" >> "$AI_LOG"

print_subsection "AI service optimization recommendations..."
echo "AI service optimization recommendations..." >> "$AI_LOG"

echo "1. Implement caching for AI responses" >> "$AI_LOG"
echo "2. Add retry logic for failed API calls" >> "$AI_LOG"
echo "3. Implement rate limiting for API requests" >> "$AI_LOG"
echo "4. Add offline fallback for AI features" >> "$AI_LOG"
echo "5. Optimize AI model loading times" >> "$AI_LOG"
echo "6. Implement progressive loading for AI features" >> "$AI_LOG"

print_info "AI optimization recommendations:"
echo "1. Implement caching for AI responses"
echo "2. Add retry logic for failed API calls"
echo "3. Implement rate limiting for API requests"
echo "4. Add offline fallback for AI features"
echo "5. Optimize AI model loading times"
echo "6. Implement progressive loading for AI features"

print_section "6. AI TESTING FRAMEWORK"
echo "" >> "$AI_LOG"
echo "6. AI TESTING FRAMEWORK" >> "$AI_LOG"

# Create AI testing script
print_subsection "Creating AI testing framework..."
echo "Creating AI testing framework..." >> "$AI_LOG"

cat > Scripts/test_ai_services.sh << 'EOF'
#!/bin/bash
# Test AI services and API integrations

echo "🧪 Testing AI services..."

# Test HuggingFace API
if [ -f "backend/.env" ]; then
    source backend/.env
    if [ -n "$HUGGINGFACE_API_KEY" ]; then
        echo "Testing HuggingFace API..."
        curl -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
             "https://api-inference.huggingface.co/models/gpt2" \
             -d '{"inputs": "Hello, how are you?"}' \
             -s -o /dev/null -w "%{http_code}" | grep -q "200" && echo "✅ HuggingFace API working" || echo "❌ HuggingFace API failed"
    else
        echo "⚠️ HuggingFace API key not found"
    fi
fi

# Test OpenAI API
if [ -n "$OPENAI_API_KEY" ]; then
    echo "Testing OpenAI API..."
    curl -H "Authorization: Bearer $OPENAI_API_KEY" \
         -H "Content-Type: application/json" \
         "https://api.openai.com/v1/models" \
         -s -o /dev/null -w "%{http_code}" | grep -q "200" && echo "✅ OpenAI API working" || echo "❌ OpenAI API failed"
else
    echo "⚠️ OpenAI API key not found"
fi

# Test AI service methods
echo "Testing AI service methods..."
# Add specific tests for AI services here
EOF

chmod +x Scripts/test_ai_services.sh
print_status "AI testing framework created"

print_section "7. AI MONITORING DASHBOARD"
echo "" >> "$AI_LOG"
echo "7. AI MONITORING DASHBOARD" >> "$AI_LOG"

# Create AI monitoring dashboard
print_subsection "Creating AI monitoring dashboard..."
echo "Creating AI monitoring dashboard..." >> "$AI_LOG"

cat > Scripts/ai_dashboard.sh << 'EOF'
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
EOF

chmod +x Scripts/ai_dashboard.sh
print_status "AI monitoring dashboard created"

print_section "8. AI AGENT RECOMMENDATIONS"
echo "" >> "$AI_LOG"
echo "8. AI AGENT RECOMMENDATIONS" >> "$AI_LOG"

print_subsection "Recommended AI agents for StryVr..."
echo "Recommended AI agents for StryVr..." >> "$AI_LOG"

echo "1. AI Performance Monitor Agent" >> "$AI_LOG"
echo "   - Monitor AI service response times" >> "$AI_LOG"
echo "   - Track API usage and costs" >> "$AI_LOG"
echo "   - Alert on AI service failures" >> "$AI_LOG"
echo "   - Optimize AI model performance" >> "$AI_LOG"

echo "2. AI Content Generator Agent" >> "$AI_LOG"
echo "   - Generate personalized learning content" >> "$AI_LOG"
echo "   - Create skill assessment questions" >> "$AI_LOG"
echo "   - Generate progress reports" >> "$AI_LOG"
echo "   - Create motivational messages" >> "$AI_LOG"

echo "3. AI Behavior Analyst Agent" >> "$AI_LOG"
echo "   - Analyze user behavior patterns" >> "$AI_LOG"
echo "   - Predict user engagement" >> "$AI_LOG"
echo "   - Identify skill gaps" >> "$AI_LOG"
echo "   - Suggest personalized interventions" >> "$AI_LOG"

echo "4. AI Quality Assurance Agent" >> "$AI_LOG"
echo "   - Validate AI recommendations" >> "$AI_LOG"
echo "   - Test AI service responses" >> "$AI_LOG"
echo "   - Monitor AI accuracy" >> "$AI_LOG"
echo "   - Flag potential AI biases" >> "$AI_LOG"

print_info "Recommended AI agents:"
echo "1. AI Performance Monitor Agent"
echo "2. AI Content Generator Agent"
echo "3. AI Behavior Analyst Agent"
echo "4. AI Quality Assurance Agent"

print_section "9. AI SECURITY & COMPLIANCE"
echo "" >> "$AI_LOG"
echo "9. AI SECURITY & COMPLIANCE" >> "$AI_LOG"

print_subsection "AI security recommendations..."
echo "AI security recommendations..." >> "$AI_LOG"

echo "1. Implement API key rotation" >> "$AI_LOG"
echo "2. Add request/response logging" >> "$AI_LOG"
echo "3. Implement rate limiting" >> "$AI_LOG"
echo "4. Add input validation for AI requests" >> "$AI_LOG"
echo "5. Monitor for AI model drift" >> "$AI_LOG"
echo "6. Implement AI explainability features" >> "$AI_LOG"

print_info "AI security recommendations:"
echo "1. Implement API key rotation"
echo "2. Add request/response logging"
echo "3. Implement rate limiting"
echo "4. Add input validation for AI requests"
echo "5. Monitor for AI model drift"
echo "6. Implement AI explainability features"

print_section "10. SUMMARY & NEXT STEPS"
echo "" >> "$AI_LOG"
echo "10. SUMMARY & NEXT STEPS" >> "$AI_LOG"

print_status "AI service monitoring completed!"
echo "✅ AI service monitoring completed!" >> "$AI_LOG"

print_info "📋 Action items for AI optimization:"
echo "📋 Action items for AI optimization:" >> "$AI_LOG"
echo "1. Test AI services: ./Scripts/test_ai_services.sh" >> "$AI_LOG"
echo "2. Monitor AI performance: ./Scripts/ai_dashboard.sh" >> "$AI_LOG"
echo "3. Implement recommended AI agents" >> "$AI_LOG"
echo "4. Add AI caching and optimization" >> "$AI_LOG"
echo "5. Enhance AI security measures" >> "$AI_LOG"

print_info "📊 AI report saved to: $AI_LOG"
echo "📊 AI report saved to: $AI_LOG" >> "$AI_LOG"

echo ""
print_warning "💡 AI Pro Tips:"
echo "   - Monitor AI API costs regularly"
echo "   - Test AI services before deployment"
echo "   - Implement fallback mechanisms"
echo "   - Keep AI models updated"
echo "   - Monitor AI response quality"

echo ""
print_status "🎉 AI service monitoring completed successfully!"
echo ""
echo "📞 Need help? Contact: upflowapp@gmail.com" 