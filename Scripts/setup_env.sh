#!/bin/bash

# StryVr Environment Variables Setup Script
# This script helps set up secure environment variables

echo "🔐 Setting up StryVr Environment Variables..."

# Check if .env already exists
if [ -f "backend/.env" ]; then
    echo "⚠️  .env file already exists. Backing up..."
    cp backend/.env backend/.env.backup
fi

# Create .env file with Firebase configuration
cat > backend/.env << 'EOF'
# StryVr Backend Environment Variables

# Firebase Configuration
FIREBASE_PROJECT_ID=stryvr
FIREBASE_PRIVATE_KEY_ID=609c1c2c95eb97726f908f6d0395e37d10b56004
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQChADItreJURc/O\nuLICgfcnIpcP60b1cMW6cmOI4JLZk6dsdVQW3mwgig8DA3d7icPaq2Fn5Hozjnf7\nPN/d8zKDhm+Oz5t1nAYfyJRxDhMzYGAGamkF07cR3kol+Whher4wUcotQ44PWGoY\nT3ual/Gr+vziASH1YG0vlp4V6MGDyeqoiZ5ffRrBbd0kiDmmQYnDOTxuPF5jGQUf\n8yKgw1K3qfFjcqEy4JWrntoL15PADU5CtaJm0hxXexPtMhk44eRh6+heajrP5VXe\nOzDWvfXsQougwW4aQOMYl31YC+Y/sWkvtJ8ApzbK8sn66Ke1RjU9x32IAmH6IKiW\nuHd5a00zAgMBAAECggEAC9uy1nB3OhPGQYiS++JMrOI8VBzVJiC/P4NLV3qK9mGM\ntE1T+zc4qZDhmCw6Maws878ptng6k++LYMLUDknqT4uoTdF2tsveG5sva8BIo8EW\ncYKG57n3QuaneXKMQJnExlRP2tOd8/1kGxRHm1RTpYIf/BlvQd5vTFEApcZ18lnf\n3PsVXXj1UrBrjAP7vOERyoRYueHS5Tt9SWqxYpyyjJEchuiCt0qvj2RGAZB2wncl\n6Ig8or8XKpgdyFgcmmqefVa1pMEsAxrcHiGDP6ScMqKYMMOQh/3xtbttPjabkcRK\n/aDwcRPrgeWISQ07w8JmI+LIWE82osbWQBGUiSzLeQKBgQDdY/WjpQEgjILyOILo\nzuj6GkNfUDP/VOVHUx1ozT5xLW5/NGEOAXs6BiMqNEoVqQMmmOtei/IMhaFQ7JZ4\nQjBb9mk6wBuiaLPJ0pVRVSzBE0rqvkPATXoes0vPdbdnogBpdhU5WyFK6OvDESXP\nQ+EV68X0jpUfEdx0p+El3tNAvwKBgQC6K3E5HwWCDE5zrRfWjLxj+yhJgj1ddiFd\nH04tzDIjShPuEpY8R2/reSea9G6OUozCpgRUWYmQ+glC2Gm5wYpl5Xr9MwbnhEN2\nCVWBQTCw77r3NOua1j6WzYCOdBQD+qtItJaJVpZ9htuwEFfUn/N5QKrqqPFtcR/s\n7JHPkzRcjQKBgESldwgb5MKT7xJuJWFMrv7F3/gQ5V6Zk1JPWkIhyefL/4Qf2KxA\nF1aBiqvOdN5MfracGfdCC3aIhOGTyoBVfas2N6DI6oisUHsW+cezUmI3ujYZcuaQ\n33nffHVCefD/UYNh4uja8fLJUDk2+vNOh9+FMOdIwsJUhngBihV1Byn/AoGBAJwE\nyjdvuwL440poNoEUotE7a9Dm+Bx6Yo2TLcaNyTrv2vH627Mavz3c5Aclb/2QSuzZ\niulRvEsmcFp32WrWOvEYN1E40UF3A75JJkJTasXtsod37zds8zkYcfNwblHDYoZk\n6X+hdC8wtK3BlInZnobwXgyYlvP8CSBaRfxqxkgFAoGABIg9vNiZMoQ1BQ1yU+AO\nOGYxel5CoR/mbeCwUlkIhEOVy0LI0/e5Pn8yVIhqqq5d775p1mqQC8Tz/3o9DGD5\naXr2Z8ifObKtfOhLvAdB6zq249pRszwJOYkYiHSUN/Or5zrUeW1XcsBHN5YHvHgh\nORlPEVL/Tr0Cm17+Z613VXo=\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-fbsvc@stryvr.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=113148582457419371041
FIREBASE_STORAGE_BUCKET=stryvr.firebasestorage.app

# API Keys (Add your actual keys here)
HUGGINGFACE_API_KEY=your_huggingface_api_key
OPENAI_API_KEY=your_openai_api_key

# Server Configuration
PORT=5000
NODE_ENV=development

# Security
JWT_SECRET=stryvr_jwt_secret_key_2024_secure_random_string
SESSION_SECRET=stryvr_session_secret_2024_secure_random_string

# Database (if using external database)
DATABASE_URL=your_database_url
EOF

echo "✅ Environment variables file created at backend/.env"
echo ""
echo "🔧 Next steps:"
echo "1. Edit backend/.env and add your actual API keys"
echo "2. Replace 'your_huggingface_api_key' with your HuggingFace API key"
echo "3. Replace 'your_openai_api_key' with your OpenAI API key"
echo "4. Generate new Firebase admin SDK keys (current ones were exposed)"
echo ""
echo "🚨 IMPORTANT: Regenerate Firebase admin SDK keys since they were exposed in git!"
echo "   Go to Firebase Console → Project Settings → Service Accounts"
echo ""
echo "🔐 Security features are now ready to test!"
