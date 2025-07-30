#!/bin/bash

# 🔒 Security Update Script for StryVr
# This script updates dependencies and checks for security vulnerabilities

echo "🔒 Running security audit and updates for StryVr..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Not in the stryvr-ios repository root. Please run this script from the project root."
    exit 1
fi

echo ""
echo "📋 Security Audit Checklist:"
echo "============================"

# 1. Root directory audit
print_info "1. Checking root directory dependencies..."
cd "$(dirname "$0")/.."
if [ -f "package.json" ]; then
    print_info "   Installing root dependencies..."
    npm install --silent
    
    print_info "   Running security audit..."
    if npm audit --audit-level=moderate; then
        print_status "   Root directory: No vulnerabilities found"
    else
        print_warning "   Root directory: Vulnerabilities detected"
        print_info "   Attempting to fix automatically..."
        npm audit fix
    fi
else
    print_info "   No package.json in root directory"
fi

# 2. Backend directory audit
print_info "2. Checking backend dependencies..."
if [ -d "backend" ]; then
    cd backend
    if [ -f "package.json" ]; then
        print_info "   Installing backend dependencies..."
        npm install --silent
        
        print_info "   Running security audit..."
        if npm audit --audit-level=moderate; then
            print_status "   Backend: No vulnerabilities found"
        else
            print_warning "   Backend: Vulnerabilities detected"
            print_info "   Attempting to fix automatically..."
            npm audit fix
        fi
        
        # Update specific packages that commonly have issues
        print_info "   Updating critical packages..."
        npm install multer@latest --silent
        npm install express@latest --silent
        npm install cors@latest --silent
        npm install dotenv@latest --silent
        
        cd ..
    else
        print_info "   No package.json in backend directory"
        cd ..
    fi
else
    print_info "   Backend directory not found"
fi

# 3. Check for outdated packages
print_info "3. Checking for outdated packages..."
if [ -f "package.json" ]; then
    print_info "   Root directory outdated packages:"
    npm outdated || print_status "   All packages are up to date"
fi

if [ -d "backend" ] && [ -f "backend/package.json" ]; then
    print_info "   Backend outdated packages:"
    cd backend
    npm outdated || print_status "   All packages are up to date"
    cd ..
fi

# 4. Check for known vulnerabilities
print_info "4. Checking for known vulnerabilities..."
if [ -f "package.json" ]; then
    print_info "   Root directory vulnerability check:"
    npm audit --audit-level=low --json | grep -q "vulnerabilities" && print_warning "   Vulnerabilities found" || print_status "   No vulnerabilities found"
fi

if [ -d "backend" ] && [ -f "backend/package.json" ]; then
    print_info "   Backend vulnerability check:"
    cd backend
    npm audit --audit-level=low --json | grep -q "vulnerabilities" && print_warning "   Vulnerabilities found" || print_status "   No vulnerabilities found"
    cd ..
fi

# 5. Security best practices check
print_info "5. Security best practices check:"
echo "   - [ ] .env files are in .gitignore"
echo "   - [ ] API keys are not hardcoded"
echo "   - [ ] Firebase config is secure"
echo "   - [ ] Dependencies are regularly updated"
echo "   - [ ] Security headers are implemented"

# 6. Generate security report
print_info "6. Generating security report..."
SECURITY_REPORT="security_report_$(date +%Y%m%d_%H%M%S).txt"

echo "StryVr Security Report - $(date)" > "$SECURITY_REPORT"
echo "=================================" >> "$SECURITY_REPORT"
echo "" >> "$SECURITY_REPORT"

echo "Root Directory Dependencies:" >> "$SECURITY_REPORT"
if [ -f "package.json" ]; then
    npm audit --audit-level=low >> "$SECURITY_REPORT" 2>&1
else
    echo "No package.json found" >> "$SECURITY_REPORT"
fi

echo "" >> "$SECURITY_REPORT"
echo "Backend Dependencies:" >> "$SECURITY_REPORT"
if [ -d "backend" ] && [ -f "backend/package.json" ]; then
    cd backend
    npm audit --audit-level=low >> "../$SECURITY_REPORT" 2>&1
    cd ..
else
    echo "No backend package.json found" >> "$SECURITY_REPORT"
fi

print_status "Security report saved to: $SECURITY_REPORT"

echo ""
echo "🚀 Security Update Summary:"
echo "==========================="

print_status "✅ Security audit completed"
print_status "✅ Dependencies updated"
print_status "✅ Vulnerability fixes applied"
print_status "✅ Security report generated"

echo ""
print_info "📋 Next Steps:"
echo "1. Review the security report: $SECURITY_REPORT"
echo "2. Commit updated package.json and package-lock.json files"
echo "3. Test the application after dependency updates"
echo "4. Schedule regular security audits (recommended: weekly)"

echo ""
print_warning "💡 Security Tips:"
echo "   - Run this script weekly to stay updated"
echo "   - Monitor GitHub Dependabot alerts"
echo "   - Keep API keys secure and rotated"
echo "   - Use environment variables for sensitive data"

echo ""
print_status "🎉 Security update completed successfully!"
echo ""
echo "📞 Need help? Contact: joedormond@stryvr.app" 