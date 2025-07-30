#!/bin/bash

# 🚀 GitHub Profile & Repository Setup Script for StryVr
# This script helps optimize your GitHub presence for maximum visibility

echo "🎯 Setting up GitHub profile and repository for StryVr..."

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

echo ""
echo "📋 GitHub Profile Optimization Checklist:"
echo "========================================"

# 1. Profile Bio
print_info "1. Update your GitHub profile bio with:"
echo "   🚀 Building StryVr - AI-powered professional development platform"
echo "   📱 iOS Developer | Swift/SwiftUI | Firebase | AI/ML"
echo "   🏢 Helping teams track performance & accelerate career growth"
echo "   🌴 Los Angeles, CA | 🔗 stryvr.app | 🐦 @josephdormond"

# 2. Profile Picture
print_info "2. Ensure you have a professional profile picture"

# 3. Location
print_info "3. Add your location (Los Angeles, CA)"

# 4. Website
print_info "4. Add website: https://stryvr.app"

# 5. Twitter/X
print_info "5. Add Twitter/X: @josephdormond"

# 6. Company
print_info "6. Add company: StryVr (Los Angeles)"

# 7. Pin Repository
print_info "7. Pin the stryvr-ios repository to your profile"

echo ""
echo "📋 Repository Optimization Checklist:"
echo "====================================="

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    print_error "Not in the stryvr-ios repository root. Please run this script from the project root."
    exit 1
fi

# 8. Repository Description
print_info "8. Set repository description to:"
echo "   'AI-powered professional development platform for workplace performance tracking and career growth'"

# 9. Topics/Tags
print_info "9. Add repository topics:"
echo "   - ios"
echo "   - swift"
echo "   - swiftui"
echo "   - firebase"
echo "   - ai"
echo "   - professional-development"
echo "   - workplace-analytics"
echo "   - career-growth"
echo "   - skill-tracking"
echo "   - enterprise-software"

# 10. Repository Settings
print_info "10. Repository settings to enable:"
echo "    - Issues"
echo "    - Discussions"
echo "    - Wiki"
echo "    - Projects"
echo "    - Security advisories"

# 11. Branch Protection
print_info "11. Set up branch protection for main branch:"
echo "    - Require pull request reviews"
echo "    - Require status checks to pass"
echo "    - Require branches to be up to date"
echo "    - Include administrators"

# 12. Issue Templates
print_info "12. Create issue templates for:"
echo "    - Bug reports"
echo "    - Feature requests"
echo "    - Documentation improvements"

# 13. Pull Request Template
print_info "13. Create pull request template"

# 14. Code of Conduct
print_info "14. Add Code of Conduct file"

# 15. Security Policy
print_info "15. Add SECURITY.md file"

echo ""
echo "📋 Social Media Integration:"
echo "============================"

# 16. Social Links
print_info "16. Add social media links to README:"
echo "    - LinkedIn: https://linkedin.com/company/stryvr-ios"
echo "    - Instagram: https://instagram.com/stryvr_app"
echo "    - Website: https://stryvr.app"

# 17. Badges
print_info "17. Add badges to README:"
echo "    - Build status"
echo "    - Code coverage"
echo "    - License"
echo "    - Swift version"
echo "    - iOS version"

echo ""
echo "📋 Content Strategy:"
echo "==================="

# 18. Regular Updates
print_info "18. Commit regularly to show activity:"
echo "    - Daily/weekly commits"
echo "    - Meaningful commit messages"
echo "    - Update documentation"

# 19. Engage with Community
print_info "19. Engage with the community:"
echo "    - Respond to issues quickly"
echo "    - Participate in discussions"
echo "    - Share updates on social media"

# 20. Showcase Features
print_info "20. Showcase key features:"
echo "    - Add screenshots to README"
echo "    - Create demo videos"
echo "    - Write blog posts about features"

echo ""
echo "🚀 Action Items:"
echo "================"

print_status "Manual steps to complete:"
echo "1. Go to https://github.com/settings/profile"
echo "2. Update your bio, location, website, and social links"
echo "3. Go to https://github.com/UpFlow-ios/StryVr-ios"
echo "4. Click 'Settings' and configure repository options"
echo "5. Add topics and description"
echo "6. Enable features (Issues, Discussions, etc.)"
echo "7. Set up branch protection rules"
echo "8. Create issue and PR templates"

echo ""
print_info "📊 After completing these steps, your GitHub profile will be optimized for:"
echo "   - Maximum visibility to potential employers"
echo "   - Attracting contributors and collaborators"
echo "   - Building credibility in the iOS development community"
echo "   - Showcasing your technical skills and project management"

echo ""
print_warning "💡 Pro Tips:"
echo "   - Keep your README updated with latest features"
echo "   - Respond to issues and PRs within 24 hours"
echo "   - Share your work on Twitter/LinkedIn regularly"
echo "   - Network with other iOS developers"

echo ""
print_status "🎉 Your GitHub profile is now optimized for success!"
echo ""
echo "📞 Need help? Contact: joedormond@stryvr.app"
echo "🔗 Follow StryVr: @stryvr_app on Instagram" 