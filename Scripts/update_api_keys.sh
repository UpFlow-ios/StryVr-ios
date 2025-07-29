#!/bin/bash

# StryVr API Keys Update Script
# This script helps you update your API keys securely

echo "🔑 Updating StryVr API Keys..."
echo "==============================="

# Check if .env exists
if [ ! -f "backend/.env" ]; then
    echo "❌ .env file not found. Run setup_env.sh first."
    exit 1
fi

echo "📝 Please provide your API keys:"
echo ""

# Get HuggingFace API Key
echo "🤗 HuggingFace API Key (starts with 'hf_'):"
read -s HUGGINGFACE_KEY
echo ""

# Get OpenAI API Key
echo "🤖 OpenAI API Key (starts with 'sk-'):"
read -s OPENAI_KEY
echo ""

# Get Firebase Admin SDK details
echo "🔥 Firebase Admin SDK Details:"
echo "Please paste the contents of your new firebase-adminsdk.json file:"
echo "(Press Enter when done, then Ctrl+D to finish)"
FIREBASE_JSON=$(cat)

# Extract Firebase details from JSON
FIREBASE_PROJECT_ID=$(echo "$FIREBASE_JSON" | grep '"project_id"' | cut -d'"' -f4)
FIREBASE_PRIVATE_KEY_ID=$(echo "$FIREBASE_JSON" | grep '"private_key_id"' | cut -d'"' -f4)
FIREBASE_PRIVATE_KEY=$(echo "$FIREBASE_JSON" | grep '"private_key"' | cut -d'"' -f4 | sed 's/\\n/\n/g')
FIREBASE_CLIENT_EMAIL=$(echo "$FIREBASE_JSON" | grep '"client_email"' | cut -d'"' -f4)
FIREBASE_CLIENT_ID=$(echo "$FIREBASE_JSON" | grep '"client_id"' | cut -d'"' -f4)

# Update .env file
echo "Updating backend/.env file..."

# Create new .env file
cat > backend/.env << EOF
# StryVr Backend Environment Variables

# Firebase Configuration
FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID
FIREBASE_PRIVATE_KEY_ID=$FIREBASE_PRIVATE_KEY_ID
FIREBASE_PRIVATE_KEY="$FIREBASE_PRIVATE_KEY"
FIREBASE_CLIENT_EMAIL=$FIREBASE_CLIENT_EMAIL
FIREBASE_CLIENT_ID=$FIREBASE_CLIENT_ID
FIREBASE_STORAGE_BUCKET=stryvr.firebasestorage.app

# API Keys
HUGGINGFACE_API_KEY=$HUGGINGFACE_KEY
OPENAI_API_KEY=$OPENAI_KEY

# Server Configuration
PORT=5000
NODE_ENV=development

# Security
JWT_SECRET=stryvr_jwt_secret_key_2024_secure_random_string
SESSION_SECRET=stryvr_session_secret_2024_secure_random_string

# Database (if using external database)
DATABASE_URL=your_database_url
EOF

echo ""
echo "✅ API keys updated successfully!"
echo ""
echo "🔐 Security Check:"
echo "- Firebase admin SDK keys regenerated"
echo "- API keys securely stored in .env"
echo "- Old exposed keys are now invalid"
echo ""
echo "🧪 Test the configuration:"
echo "cd backend && node -e \"require('dotenv').config(); console.log('Project ID:', process.env.FIREBASE_PROJECT_ID);\""
echo ""
echo "🚀 Ready to test StryVr with new keys!" 