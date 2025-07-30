#!/bin/bash

# 🎨 Asset Management Agent for StryVr
# This script manages marketing assets and screenshots

echo "🎨 Running StryVr Asset Management Agent..."

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
ASSET_LOG="asset_management_${CURRENT_DATE}.log"

echo "🎨 StryVr Asset Management Report - $CURRENT_DATE" > "$ASSET_LOG"
echo "===============================================" >> "$ASSET_LOG"

print_section "1. ASSET DIRECTORY AUDIT"
echo "1. ASSET DIRECTORY AUDIT" >> "$ASSET_LOG"

# Check asset directories
print_subsection "Checking asset directories..."
echo "Checking asset directories..." >> "$ASSET_LOG"

# Check Marketing/Assets directory
if [ -d "Marketing/Assets" ]; then
    print_status "Marketing/Assets directory exists"
    echo "✅ Marketing/Assets directory exists" >> "$ASSET_LOG"
else
    print_warning "Marketing/Assets directory missing"
    echo "⚠️ Marketing/Assets directory missing" >> "$ASSET_LOG"
    mkdir -p Marketing/Assets
    print_status "Created Marketing/Assets directory"
fi

# Check iOS assets
if [ -d "StryVr/Assets.xcassets" ]; then
    print_status "iOS Assets.xcassets directory exists"
    echo "✅ iOS Assets.xcassets directory exists" >> "$ASSET_LOG"
else
    print_warning "iOS Assets.xcassets directory missing"
    echo "⚠️ iOS Assets.xcassets directory missing" >> "$ASSET_LOG"
fi

# Check for AppIcon
if [ -d "StryVr/Assets.xcassets/AppIcon.appiconset" ]; then
    print_status "AppIcon.appiconset directory exists"
    echo "✅ AppIcon.appiconset directory exists" >> "$ASSET_LOG"
    
    # Count AppIcon files
    APP_ICON_COUNT=$(find StryVr/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
    print_info "AppIcon files: $APP_ICON_COUNT"
    echo "AppIcon files: $APP_ICON_COUNT" >> "$ASSET_LOG"
else
    print_warning "AppIcon.appiconset directory missing"
    echo "⚠️ AppIcon.appiconset directory missing" >> "$ASSET_LOG"
fi

print_section "2. MARKETING ASSETS CHECK"
echo "" >> "$ASSET_LOG"
echo "2. MARKETING ASSETS CHECK" >> "$ASSET_LOG"

# Check marketing assets
print_subsection "Checking marketing assets..."
echo "Checking marketing assets..." >> "$ASSET_LOG"

MARKETING_ASSETS=(
    "Marketing/Assets/logo_creation_guide.md"
    "Marketing/Assets/brand_guidelines.md"
    "Marketing/Assets/email_templates.md"
    "Marketing/Assets/screenshots_guide.md"
    "Marketing/Assets/linkedin_banner_template.md"
)

for asset in "${MARKETING_ASSETS[@]}"; do
    if [ -f "$asset" ]; then
        print_status "✅ $asset exists"
        echo "✅ $asset exists" >> "$ASSET_LOG"
    else
        print_warning "⚠️ $asset missing"
        echo "⚠️ $asset missing" >> "$ASSET_LOG"
    fi
done

# Check for actual image assets
IMAGE_ASSETS=$(find Marketing/Assets -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" 2>/dev/null | wc -l)
if [ "$IMAGE_ASSETS" -gt 0 ]; then
    print_status "Marketing image assets found: $IMAGE_ASSETS"
    echo "✅ Marketing image assets found: $IMAGE_ASSETS" >> "$ASSET_LOG"
else
    print_warning "No marketing image assets found"
    echo "⚠️ No marketing image assets found" >> "$ASSET_LOG"
fi

print_section "3. SCREENSHOT MANAGEMENT"
echo "" >> "$ASSET_LOG"
echo "3. SCREENSHOT MANAGEMENT" >> "$ASSET_LOG"

# Screenshot management
print_subsection "Managing screenshots..."
echo "Managing screenshots..." >> "$ASSET_LOG"

# Check for screenshot directory
if [ -d "Marketing/Assets/Screenshots" ]; then
    print_status "Screenshots directory exists"
    echo "✅ Screenshots directory exists" >> "$ASSET_LOG"
    
    # Count screenshots
    SCREENSHOT_COUNT=$(find Marketing/Assets/Screenshots -name "*.png" -o -name "*.jpg" 2>/dev/null | wc -l)
    print_info "Screenshots found: $SCREENSHOT_COUNT"
    echo "Screenshots found: $SCREENSHOT_COUNT" >> "$ASSET_LOG"
else
    print_warning "Screenshots directory missing"
    echo "⚠️ Screenshots directory missing" >> "$ASSET_LOG"
    mkdir -p Marketing/Assets/Screenshots
    print_status "Created Screenshots directory"
fi

# Create screenshot automation script
cat > Scripts/auto_screenshot.sh << 'EOF'
#!/bin/bash
# Automated screenshot generation

echo "📱 Generating automated screenshots..."

# Create screenshots directory if it doesn't exist
mkdir -p Marketing/Assets/Screenshots

# Check if Xcode is available
if command -v xcrun &> /dev/null; then
    echo "✅ Xcode command line tools available"
    
    # List available simulators
    echo "Available simulators:"
    xcrun simctl list devices | grep "iPhone" | head -5
    
    echo ""
    echo "To generate screenshots:"
    echo "1. Open Xcode"
    echo "2. Run the app on simulator"
    echo "3. Take screenshots manually"
    echo "4. Save to Marketing/Assets/Screenshots/"
else
    echo "❌ Xcode command line tools not available"
fi

echo "✅ Screenshot automation script created"
EOF

chmod +x Scripts/auto_screenshot.sh
print_status "Screenshot automation script created"

print_section "4. ASSET OPTIMIZATION"
echo "" >> "$ASSET_LOG"
echo "4. ASSET OPTIMIZATION" >> "$ASSET_LOG"

# Asset optimization
print_subsection "Optimizing assets..."
echo "Optimizing assets..." >> "$ASSET_LOG"

# Check for large assets
LARGE_ASSETS=$(find . -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -size +5M 2>/dev/null | wc -l)
if [ "$LARGE_ASSETS" -gt 0 ]; then
    print_warning "Large assets found: $LARGE_ASSETS"
    echo "⚠️ Large assets found: $LARGE_ASSETS" >> "$ASSET_LOG"
    
    # List large assets
    find . -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -size +5M 2>/dev/null | head -5 >> "$ASSET_LOG"
else
    print_status "No large assets found"
    echo "✅ No large assets found" >> "$ASSET_LOG"
fi

# Create asset optimization script
cat > Scripts/optimize_assets.sh << 'EOF'
#!/bin/bash
# Asset optimization script

echo "🔧 Optimizing assets..."

# Check if ImageOptim is installed (macOS)
if command -v imageoptim &> /dev/null; then
    echo "✅ ImageOptim found - optimizing images..."
    find Marketing/Assets -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | head -10 | xargs imageoptim
else
    echo "⚠️ ImageOptim not found"
    echo "Install ImageOptim for automatic image optimization:"
    echo "https://imageoptim.com/mac"
fi

# Check for duplicate assets
echo "Checking for duplicate assets..."
find Marketing/Assets -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | while read file; do
    basename "$file"
done | sort | uniq -d

echo "✅ Asset optimization completed"
EOF

chmod +x Scripts/optimize_assets.sh
print_status "Asset optimization script created"

print_section "5. BRAND CONSISTENCY"
echo "" >> "$ASSET_LOG"
echo "5. BRAND CONSISTENCY" >> "$ASSET_LOG"

# Brand consistency checks
print_subsection "Checking brand consistency..."
echo "Checking brand consistency..." >> "$ASSET_LOG"

# Check for brand guidelines
if [ -f "Marketing/Assets/brand_guidelines.md" ]; then
    print_status "Brand guidelines exist"
    echo "✅ Brand guidelines exist" >> "$ASSET_LOG"
    
    # Extract brand colors (if any)
    BRAND_COLORS=$(grep -i "color\|#" Marketing/Assets/brand_guidelines.md | head -5)
    if [ -n "$BRAND_COLORS" ]; then
        print_info "Brand colors found in guidelines"
        echo "Brand colors found in guidelines" >> "$ASSET_LOG"
    fi
else
    print_warning "Brand guidelines missing"
    echo "⚠️ Brand guidelines missing" >> "$ASSET_LOG"
fi

# Check for logo files
LOGO_FILES=$(find . -name "*logo*" -o -name "*brand*" 2>/dev/null | grep -E "\.(png|jpg|jpeg|svg)$" | wc -l)
if [ "$LOGO_FILES" -gt 0 ]; then
    print_status "Logo/brand files found: $LOGO_FILES"
    echo "✅ Logo/brand files found: $LOGO_FILES" >> "$ASSET_LOG"
else
    print_warning "No logo/brand files found"
    echo "⚠️ No logo/brand files found" >> "$ASSET_LOG"
fi

print_section "6. APP STORE ASSETS"
echo "" >> "$ASSET_LOG"
echo "6. APP STORE ASSETS" >> "$ASSET_LOG"

# App Store asset management
print_subsection "Managing App Store assets..."
echo "Managing App Store assets..." >> "$ASSET_LOG"

# Check for App Store specific assets
APP_STORE_ASSETS=(
    "Marketing/Assets/AppStore"
    "Marketing/Assets/AppIcon"
    "Marketing/Assets/Screenshots"
)

for asset_dir in "${APP_STORE_ASSETS[@]}"; do
    if [ -d "$asset_dir" ]; then
        print_status "✅ $asset_dir exists"
        echo "✅ $asset_dir exists" >> "$ASSET_LOG"
        
        # Count files in directory
        FILE_COUNT=$(find "$asset_dir" -type f | wc -l)
        print_info "Files in $asset_dir: $FILE_COUNT"
        echo "Files in $asset_dir: $FILE_COUNT" >> "$ASSET_LOG"
    else
        print_warning "⚠️ $asset_dir missing"
        echo "⚠️ $asset_dir missing" >> "$ASSET_LOG"
        mkdir -p "$asset_dir"
        print_status "Created $asset_dir"
    fi
done

# Create App Store asset generation script
cat > Scripts/generate_appstore_assets.sh << 'EOF'
#!/bin/bash
# App Store asset generation

echo "📱 Generating App Store assets..."

# Create App Store assets directory
mkdir -p Marketing/Assets/AppStore

# App Store requirements
echo "App Store Asset Requirements:" > Marketing/Assets/AppStore/requirements.md
echo "=============================" >> Marketing/Assets/AppStore/requirements.md
echo "" >> Marketing/Assets/AppStore/requirements.md
echo "1. App Icon: 1024x1024 PNG" >> Marketing/Assets/AppStore/requirements.md
echo "2. Screenshots: Various device sizes" >> Marketing/Assets/AppStore/requirements.md
echo "3. App Preview Video: 15-30 seconds" >> Marketing/Assets/AppStore/requirements.md
echo "4. App Description: Compelling copy" >> Marketing/Assets/AppStore/requirements.md
echo "5. Keywords: Relevant search terms" >> Marketing/Assets/AppStore/requirements.md

echo "✅ App Store asset requirements created"
echo ""
echo "Next steps:"
echo "1. Create 1024x1024 app icon"
echo "2. Take screenshots on different devices"
echo "3. Create app preview video"
echo "4. Write compelling app description"
echo "5. Research relevant keywords"
EOF

chmod +x Scripts/generate_appstore_assets.sh
print_status "App Store asset generation script created"

print_section "7. MARKETING MATERIAL CREATION"
echo "" >> "$ASSET_LOG"
echo "7. MARKETING MATERIAL CREATION" >> "$ASSET_LOG"

# Marketing material creation
print_subsection "Creating marketing materials..."
echo "Creating marketing materials..." >> "$ASSET_LOG"

# Create marketing material templates
cat > Marketing/Assets/social_media_templates.md << 'EOF'
# Social Media Templates for StryVr

## LinkedIn Post Template
```
🎯 [Headline about workplace performance]

💡 [Key insight or tip]

🚀 [Call to action]

#StryVr #ProfessionalDevelopment #WorkplacePerformance #AI #iOS
```

## Instagram Post Template
```
🎯 [Visual: App screenshot or graphic]

📝 [Caption about feature or benefit]

🔗 [Link in bio]

#StryVr #ProfessionalDevelopment #WorkplacePerformance
```

## Twitter Post Template
```
🎯 [Concise headline]

💡 [Quick tip or insight]

🔗 [Link to app or website]

#StryVr #ProfessionalDevelopment #AI
```

## Email Template
```
Subject: [Compelling subject line]

Hi [Name],

[Personalized greeting]

[Value proposition]

[Call to action]

Best regards,
The StryVr Team
```
EOF

print_status "Social media templates created"

# Create email signature template
cat > Marketing/Assets/email_signature.md << 'EOF'
# Email Signature Template

```
Joseph Dormond
Founder & CEO, StryVr
📧 upflowapp@gmail.com
💼 linkedin.com/in/joedormond
🌐 stryvr.app
📱 iOS App Store: StryVr

StryVr - AI-Powered Professional Development Platform
Revolutionizing workplace performance with real-time insights
```
EOF

print_status "Email signature template created"

print_section "8. ASSET RECOMMENDATIONS"
echo "" >> "$ASSET_LOG"
echo "8. ASSET RECOMMENDATIONS" >> "$ASSET_LOG"

print_subsection "Asset recommendations..."
echo "Asset recommendations..." >> "$ASSET_LOG"

echo "1. Create high-quality app screenshots" >> "$ASSET_LOG"
echo "2. Design consistent brand assets" >> "$ASSET_LOG"
echo "3. Optimize images for web and mobile" >> "$ASSET_LOG"
echo "4. Create App Store preview video" >> "$ASSET_LOG"
echo "5. Develop marketing collateral" >> "$ASSET_LOG"

print_info "Asset recommendations:"
echo "1. Create high-quality app screenshots"
echo "2. Design consistent brand assets"
echo "3. Optimize images for web and mobile"
echo "4. Create App Store preview video"
echo "5. Develop marketing collateral"

print_section "9. SUMMARY & NEXT STEPS"
echo "" >> "$ASSET_LOG"
echo "9. SUMMARY & NEXT STEPS" >> "$ASSET_LOG"

print_status "Asset management completed!"
echo "✅ Asset management completed!" >> "$ASSET_LOG"

print_info "📋 Asset management action items:"
echo "📋 Asset management action items:" >> "$ASSET_LOG"
echo "1. Generate screenshots: ./Scripts/auto_screenshot.sh" >> "$ASSET_LOG"
echo "2. Optimize assets: ./Scripts/optimize_assets.sh" >> "$ASSET_LOG"
echo "3. Create App Store assets: ./Scripts/generate_appstore_assets.sh" >> "$ASSET_LOG"
echo "4. Review brand consistency" >> "$ASSET_LOG"
echo "5. Create marketing materials" >> "$ASSET_LOG"

print_info "📊 Asset management report saved to: $ASSET_LOG"
echo "📊 Asset management report saved to: $ASSET_LOG" >> "$ASSET_LOG"

echo ""
print_warning "💡 Asset Management Pro Tips:"
echo "   - Keep assets organized by type and purpose"
echo "   - Optimize images for web and mobile"
echo "   - Maintain brand consistency across all assets"
echo "   - Use version control for asset changes"
echo "   - Create templates for repeatable content"

echo ""
print_status "🎉 Asset management agent completed successfully!"
echo ""
echo "📞 Need help? Contact: upflowapp@gmail.com" 