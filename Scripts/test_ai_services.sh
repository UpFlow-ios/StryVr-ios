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
