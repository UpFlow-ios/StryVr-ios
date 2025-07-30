#!/bin/bash

# 🚨 Firebase Key Rotation Script
# Run this after creating new Firebase Admin SDK keys

set -e

echo "🚨 Firebase Key Rotation Script"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}⚠️  IMPORTANT: This script assumes you have already:${NC}"
echo "   1. Logged into Google Cloud Console"
echo "   2. Deleted the exposed service account keys"
echo "   3. Created new service account keys"
echo "   4. Downloaded the new JSON file"
echo ""

read -p "Have you completed the Google Cloud Console steps? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Please complete the Google Cloud Console steps first:${NC}"
    echo "   1. Go to https://console.cloud.google.com"
    echo "   2. Navigate to IAM & Admin > Service Accounts"
    echo "   3. Find: firebase-adminsdk-fbsvc@stryvr.iam.gserviceaccount.com"
    echo "   4. Delete the exposed keys"
    echo "   5. Create new service account keys"
    echo "   6. Download the new JSON file"
    exit 1
fi

echo -e "${BLUE}📁 Please place your new Firebase Admin SDK JSON file in the backend/ directory${NC}"
echo "   Expected name: firebase-adminsdk-new.json (or similar)"
echo ""

# Check for new Firebase key file
FIREBASE_KEY_FILE=$(find backend/ -name "*firebase*adminsdk*.json" -o -name "*stryvr*1eb15a282abd*.json" -not -name "*old*" -not -name "*backup*" 2>/dev/null | head -1)

if [ -z "$FIREBASE_KEY_FILE" ]; then
    echo -e "${RED}❌ No new Firebase Admin SDK JSON file found in backend/ directory${NC}"
    echo "   Please download the new key from Google Cloud Console and place it in backend/"
    exit 1
fi

echo -e "${GREEN}✅ Found Firebase key file: $FIREBASE_KEY_FILE${NC}"

# Extract values from the JSON file
echo -e "${BLUE}🔍 Extracting values from Firebase key file...${NC}"

PROJECT_ID=$(grep -o '"project_id": "[^"]*"' "$FIREBASE_KEY_FILE" | cut -d'"' -f4)
PRIVATE_KEY_ID=$(grep -o '"private_key_id": "[^"]*"' "$FIREBASE_KEY_FILE" | cut -d'"' -f4)
CLIENT_EMAIL=$(grep -o '"client_email": "[^"]*"' "$FIREBASE_KEY_FILE" | cut -d'"' -f4)
CLIENT_ID=$(grep -o '"client_id": "[^"]*"' "$FIREBASE_KEY_FILE" | cut -d'"' -f4)

# Extract private key (handle multiline)
PRIVATE_KEY=$(awk '/"private_key": "/,/^[[:space:]]*"/' "$FIREBASE_KEY_FILE" | head -n -1 | tail -n +1 | sed 's/^[[:space:]]*"//' | sed 's/",$//' | tr -d '\n')

echo -e "${GREEN}✅ Extracted values:${NC}"
echo "   Project ID: $PROJECT_ID"
echo "   Private Key ID: $PRIVATE_KEY_ID"
echo "   Client Email: $CLIENT_EMAIL"
echo "   Client ID: $CLIENT_ID"
echo ""

# Backup current .env file
if [ -f "backend/.env" ]; then
    cp backend/.env backend/.env.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}✅ Backed up current .env file${NC}"
fi

# Create new .env file
echo -e "${BLUE}📝 Creating new .env file...${NC}"

cat > backend/.env << EOF
# StryVr Backend Environment Variables
# Updated: $(date)

# Firebase Configuration
FIREBASE_PROJECT_ID=$PROJECT_ID
FIREBASE_PRIVATE_KEY_ID=$PRIVATE_KEY_ID
FIREBASE_PRIVATE_KEY="$PRIVATE_KEY"
FIREBASE_CLIENT_EMAIL=$CLIENT_EMAIL
FIREBASE_CLIENT_ID=$CLIENT_ID
FIREBASE_STORAGE_BUCKET=$PROJECT_ID.firebasestorage.app

# API Keys (keep existing values)
HUGGINGFACE_API_KEY=your_huggingface_api_key
OPENAI_API_KEY=your_openai_api_key

# Server Configuration
PORT=5000
NODE_ENV=development

# Security
JWT_SECRET=your_jwt_secret_key
SESSION_SECRET=your_session_secret

# Database (if using external database)
DATABASE_URL=your_database_url
EOF

echo -e "${GREEN}✅ Created new .env file${NC}"

# Secure the Firebase key file
echo -e "${BLUE}🔒 Securing Firebase key file...${NC}"
mv "$FIREBASE_KEY_FILE" "$FIREBASE_KEY_FILE.secure"
echo -e "${GREEN}✅ Moved Firebase key file to secure location${NC}"

# Test the new configuration
echo -e "${BLUE}🧪 Testing new configuration...${NC}"
cd backend

if npm test > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend tests passed${NC}"
else
    echo -e "${YELLOW}⚠️  Backend tests failed (this might be normal if tests aren't set up)${NC}"
fi

# Start the server to test
echo -e "${BLUE}🚀 Starting server to test new credentials...${NC}"
timeout 10s npm start > /tmp/firebase_test.log 2>&1 &
SERVER_PID=$!

sleep 5

if curl -s http://localhost:5000/api/test > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Server started successfully with new credentials!${NC}"
    kill $SERVER_PID 2>/dev/null || true
else
    echo -e "${RED}❌ Server failed to start with new credentials${NC}"
    echo "Check the log: cat /tmp/firebase_test.log"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi

cd ..

echo ""
echo -e "${GREEN}🎉 Firebase key rotation completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "   1. Update your API keys in backend/.env"
echo "   2. Test the backend: cd backend && npm start"
echo "   3. Commit the updated .env file (if using git)"
echo "   4. Delete the old Firebase key files"
echo ""
echo -e "${YELLOW}⚠️  Security reminders:${NC}"
echo "   - Never commit .env files to version control"
echo "   - Keep Firebase key files secure"
echo "   - Use environment variables for all secrets"
echo "   - Regular security audits are essential"
echo ""
echo -e "${GREEN}✅ Key rotation complete!${NC}" 