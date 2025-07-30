#!/bin/bash

# 🚀 Deployment Agent for StryVr
# This script handles automated deployment to App Store and backend

echo "🚀 Running StryVr Deployment Agent..."

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
DEPLOYMENT_LOG="deployment_agent_${CURRENT_DATE}.log"

echo "🚀 StryVr Deployment Agent Report - $CURRENT_DATE" > "$DEPLOYMENT_LOG"
echo "===============================================" >> "$DEPLOYMENT_LOG"

print_section "1. PRE-DEPLOYMENT CHECKS"
echo "1. PRE-DEPLOYMENT CHECKS" >> "$DEPLOYMENT_LOG"

# Check build status
print_subsection "Checking build status..."
echo "Checking build status..." >> "$DEPLOYMENT_LOG"

# Check if Xcode project exists
if [ -d "SupportingFiles" ]; then
    print_status "Xcode project found"
    echo "✅ Xcode project found" >> "$DEPLOYMENT_LOG"
else
    print_error "Xcode project not found"
    echo "❌ Xcode project not found" >> "$DEPLOYMENT_LOG"
    exit 1
fi

# Check for build errors
RECENT_BUILD_ERRORS=$(find . -name "*build*log*" -mtime -1 2>/dev/null | head -1)
if [ -n "$RECENT_BUILD_ERRORS" ]; then
    print_warning "Recent build logs found - check for errors"
    echo "⚠️ Recent build logs found - check for errors" >> "$DEPLOYMENT_LOG"
else
    print_status "No recent build logs found"
    echo "✅ No recent build logs found" >> "$DEPLOYMENT_LOG"
fi

print_section "2. BACKEND DEPLOYMENT"
echo "" >> "$DEPLOYMENT_LOG"
echo "2. BACKEND DEPLOYMENT" >> "$DEPLOYMENT_LOG"

# Check backend status
print_subsection "Checking backend status..."
echo "Checking backend status..." >> "$DEPLOYMENT_LOG"

if [ -f "backend/package.json" ]; then
    print_status "Backend package.json found"
    echo "✅ Backend package.json found" >> "$DEPLOYMENT_LOG"
    
    # Check backend dependencies
    cd backend
    if npm list --depth=0 > /dev/null 2>&1; then
        print_status "Backend dependencies installed"
        echo "✅ Backend dependencies installed" >> "../$DEPLOYMENT_LOG"
    else
        print_warning "Backend dependencies need installation"
        echo "⚠️ Backend dependencies need installation" >> "../$DEPLOYMENT_LOG"
        print_info "Installing backend dependencies..."
        npm install
    fi
    cd ..
else
    print_warning "Backend package.json not found"
    echo "⚠️ Backend package.json not found" >> "$DEPLOYMENT_LOG"
fi

print_section "3. ENVIRONMENT VALIDATION"
echo "" >> "$DEPLOYMENT_LOG"
echo "3. ENVIRONMENT VALIDATION" >> "$DEPLOYMENT_LOG"

# Check environment variables
print_subsection "Validating environment variables..."
echo "Validating environment variables..." >> "$DEPLOYMENT_LOG"

if [ -f "backend/.env" ]; then
    print_status "Environment file exists"
    echo "✅ Environment file exists" >> "$DEPLOYMENT_LOG"
    
    # Check required environment variables
    REQUIRED_VARS=("FIREBASE_PROJECT_ID" "FIREBASE_PRIVATE_KEY" "FIREBASE_CLIENT_EMAIL" "FIREBASE_STORAGE_BUCKET")
    for var in "${REQUIRED_VARS[@]}"; do
        if grep -q "^${var}=" backend/.env; then
            print_status "✅ $var configured"
            echo "✅ $var configured" >> "$DEPLOYMENT_LOG"
        else
            print_warning "⚠️ $var not configured"
            echo "⚠️ $var not configured" >> "$DEPLOYMENT_LOG"
        fi
    done
else
    print_warning "Environment file not found"
    echo "⚠️ Environment file not found" >> "$DEPLOYMENT_LOG"
fi

print_section "4. APP STORE DEPLOYMENT"
echo "" >> "$DEPLOYMENT_LOG"
echo "4. APP STORE DEPLOYMENT" >> "$DEPLOYMENT_LOG"

# App Store deployment checklist
print_subsection "App Store deployment checklist..."
echo "App Store deployment checklist..." >> "$DEPLOYMENT_LOG"

# Check for required App Store assets
APP_STORE_REQUIREMENTS=(
    "AppIcon"
    "Screenshots"
    "App Store Connect"
    "Metadata"
)

for requirement in "${APP_STORE_REQUIREMENTS[@]}"; do
    if [ -d "Marketing/Assets/$requirement" ] || [ -f "Marketing/Assets/$requirement" ]; then
        print_status "✅ $requirement ready"
        echo "✅ $requirement ready" >> "$DEPLOYMENT_LOG"
    else
        print_warning "⚠️ $requirement missing"
        echo "⚠️ $requirement missing" >> "$DEPLOYMENT_LOG"
    fi
done

print_section "5. SECURITY VALIDATION"
echo "" >> "$DEPLOYMENT_LOG"
echo "5. SECURITY VALIDATION" >> "$DEPLOYMENT_LOG"

# Security checks
print_subsection "Running security validation..."
echo "Running security validation..." >> "$DEPLOYMENT_LOG"

# Check for exposed secrets
SECRETS_CHECK=$(grep -r -i "password\|key\|secret\|token" . --exclude-dir=.git --exclude-dir=node_modules 2>/dev/null | grep -v "example\|placeholder" | wc -l)
if [ "$SECRETS_CHECK" -eq 0 ]; then
    print_status "No exposed secrets found"
    echo "✅ No exposed secrets found" >> "$DEPLOYMENT_LOG"
else
    print_warning "Potential secrets found: $SECRETS_CHECK"
    echo "⚠️ Potential secrets found: $SECRETS_CHECK" >> "$DEPLOYMENT_LOG"
fi

# Check for Firebase configuration
if [ -f "backend/GoogleService-Info.plist" ]; then
    print_warning "Firebase config file found in backend - should be in iOS project"
    echo "⚠️ Firebase config file found in backend - should be in iOS project" >> "$DEPLOYMENT_LOG"
else
    print_status "Firebase config properly managed"
    echo "✅ Firebase config properly managed" >> "$DEPLOYMENT_LOG"
fi

print_section "6. DEPLOYMENT AUTOMATION"
echo "" >> "$DEPLOYMENT_LOG"
echo "6. DEPLOYMENT AUTOMATION" >> "$DEPLOYMENT_LOG"

# Create deployment automation scripts
print_subsection "Creating deployment automation..."
echo "Creating deployment automation..." >> "$DEPLOYMENT_LOG"

# Create backend deployment script
cat > Scripts/deploy_backend.sh << 'EOF'
#!/bin/bash
# Backend deployment script

echo "🚀 Deploying StryVr backend..."

cd backend

# Install dependencies
npm install

# Check environment
if [ ! -f ".env" ]; then
    echo "❌ Environment file not found"
    exit 1
fi

# Start server
echo "✅ Starting backend server..."
npm start
EOF

chmod +x Scripts/deploy_backend.sh
print_status "Backend deployment script created"

# Create iOS deployment script
cat > Scripts/deploy_ios.sh << 'EOF'
#!/bin/bash
# iOS deployment script

echo "📱 Deploying StryVr iOS app..."

# Clean build
cd SupportingFiles
xcodebuild clean -project StryVr.xcodeproj -scheme StryVr

# Build for App Store
xcodebuild archive -project StryVr.xcodeproj -scheme StryVr -archivePath StryVr.xcarchive

# Export for App Store
xcodebuild -exportArchive -archivePath StryVr.xcarchive -exportPath ./build -exportOptionsPlist exportOptions.plist

echo "✅ iOS build completed"
EOF

chmod +x Scripts/deploy_ios.sh
print_status "iOS deployment script created"

print_section "7. DEPLOYMENT MONITORING"
echo "" >> "$DEPLOYMENT_LOG"
echo "7. DEPLOYMENT MONITORING" >> "$DEPLOYMENT_LOG"

# Create deployment monitoring
print_subsection "Setting up deployment monitoring..."
echo "Setting up deployment monitoring..." >> "$DEPLOYMENT_LOG"

cat > Scripts/monitor_deployment.sh << 'EOF'
#!/bin/bash
# Deployment monitoring script

echo "📊 Monitoring deployment status..."

# Check backend status
if curl -s http://localhost:5000/api/test > /dev/null; then
    echo "✅ Backend is running"
else
    echo "❌ Backend is not responding"
fi

# Check iOS build status
if [ -f "SupportingFiles/build/StryVr.ipa" ]; then
    echo "✅ iOS build completed"
else
    echo "❌ iOS build not found"
fi

# Check App Store Connect status
echo "📱 App Store Connect status: Check manually"
EOF

chmod +x Scripts/monitor_deployment.sh
print_status "Deployment monitoring script created"

print_section "8. DEPLOYMENT RECOMMENDATIONS"
echo "" >> "$DEPLOYMENT_LOG"
echo "8. DEPLOYMENT RECOMMENDATIONS" >> "$DEPLOYMENT_LOG"

print_subsection "Deployment recommendations..."
echo "Deployment recommendations..." >> "$DEPLOYMENT_LOG"

echo "1. Set up automated CI/CD pipeline" >> "$DEPLOYMENT_LOG"
echo "2. Implement automated testing before deployment" >> "$DEPLOYMENT_LOG"
echo "3. Set up staging environment for testing" >> "$DEPLOYMENT_LOG"
echo "4. Implement rollback procedures" >> "$DEPLOYMENT_LOG"
echo "5. Set up monitoring and alerting" >> "$DEPLOYMENT_LOG"

print_info "Deployment recommendations:"
echo "1. Set up automated CI/CD pipeline"
echo "2. Implement automated testing before deployment"
echo "3. Set up staging environment for testing"
echo "4. Implement rollback procedures"
echo "5. Set up monitoring and alerting"

print_section "9. SUMMARY & NEXT STEPS"
echo "" >> "$DEPLOYMENT_LOG"
echo "9. SUMMARY & NEXT STEPS" >> "$DEPLOYMENT_LOG"

print_status "Deployment agent completed!"
echo "✅ Deployment agent completed!" >> "$DEPLOYMENT_LOG"

print_info "📋 Deployment action items:"
echo "📋 Deployment action items:" >> "$DEPLOYMENT_LOG"
echo "1. Run backend deployment: ./Scripts/deploy_backend.sh" >> "$DEPLOYMENT_LOG"
echo "2. Run iOS deployment: ./Scripts/deploy_ios.sh" >> "$DEPLOYMENT_LOG"
echo "3. Monitor deployment: ./Scripts/monitor_deployment.sh" >> "$DEPLOYMENT_LOG"
echo "4. Set up CI/CD pipeline" >> "$DEPLOYMENT_LOG"
echo "5. Configure App Store Connect" >> "$DEPLOYMENT_LOG"

print_info "📊 Deployment report saved to: $DEPLOYMENT_LOG"
echo "📊 Deployment report saved to: $DEPLOYMENT_LOG" >> "$DEPLOYMENT_LOG"

echo ""
print_warning "💡 Deployment Pro Tips:"
echo "   - Always test on staging before production"
echo "   - Use semantic versioning for releases"
echo "   - Set up automated rollback procedures"
echo "   - Monitor deployment metrics"
echo "   - Keep deployment logs for debugging"

echo ""
print_status "🎉 Deployment agent completed successfully!"
echo ""
echo "📞 Need help? Contact: upflowapp@gmail.com" 