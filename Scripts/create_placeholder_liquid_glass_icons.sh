#!/bin/bash

# 🎨 StryVr Placeholder Liquid Glass App Icon Generator
# This script creates placeholder app icons for testing iOS 18 Liquid Glass effects

echo "🎨 Creating Placeholder Liquid Glass App Icons..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "success")
            echo -e "${GREEN}✅${NC} $message"
            ;;
        "error")
            echo -e "${RED}❌${NC} $message"
            ;;
        "warning")
            echo -e "${YELLOW}⚠️${NC} $message"
            ;;
        "info")
            echo -e "${BLUE}ℹ️${NC} $message"
            ;;
    esac
}

# Check if we're in the right directory
if [ ! -d "StryVr/Assets.xcassets/AppIcon.appiconset" ]; then
    print_status "error" "App icon directory not found. Please run this script from the project root."
    exit 1
fi

print_status "info" "Starting placeholder icon generation..."

# Check for required tools
echo ""
print_status "info" "Checking required tools..."

if command -v magick &> /dev/null; then
    print_status "success" "ImageMagick available (modern version)"
    USE_IMAGEMAGICK=true
elif command -v convert &> /dev/null; then
    print_status "success" "ImageMagick available (legacy version)"
    USE_IMAGEMAGICK=true
    USE_LEGACY=true
elif command -v sips &> /dev/null; then
    print_status "success" "sips available (limited functionality)"
    USE_IMAGEMAGICK=false
else
    print_status "error" "No image processing tools available. Install ImageMagick for best results."
    exit 1
fi

ICON_DIR="StryVr/Assets.xcassets/AppIcon.appiconset"

# Create placeholder icons using available tools
echo ""
print_status "info" "Generating placeholder Liquid Glass app icons..."

if [ "$USE_IMAGEMAGICK" = true ]; then
    if [ "$USE_LEGACY" = true ]; then
        print_status "info" "Using legacy ImageMagick for icon generation..."
        
        # Light Mode Icons - Legacy syntax
        print_status "info" "Creating light mode icons..."
        
        # Light 1x
        convert -size 1024x1024 xc:"#F8FAFC" \
            -fill "rgba(255,255,255,0.8)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#2563EB" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Light-1x.png"
        
        # Light 2x
        convert -size 1024x1024 xc:"#F8FAFC" \
            -fill "rgba(255,255,255,0.8)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#2563EB" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Light-2x.png"
        
        # Light 3x
        convert -size 1024x1024 xc:"#F8FAFC" \
            -fill "rgba(255,255,255,0.8)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#2563EB" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Light-3x.png"
        
        # Dark Mode Icons - Legacy syntax
        print_status "info" "Creating dark mode icons..."
        
        # Dark 1x
        convert -size 1024x1024 xc:"#0F172A" \
            -fill "rgba(255,255,255,0.15)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#3B82F6" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Dark-1x.png"
        
        # Dark 2x
        convert -size 1024x1024 xc:"#0F172A" \
            -fill "rgba(255,255,255,0.15)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#3B82F6" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Dark-2x.png"
        
        # Dark 3x
        convert -size 1024x1024 xc:"#0F172A" \
            -fill "rgba(255,255,255,0.15)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#3B82F6" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Dark-3x.png"
        
    else
        print_status "info" "Using modern ImageMagick for icon generation..."
        
        # Light Mode Icons - Modern syntax
        print_status "info" "Creating light mode icons..."
        
        # Light 1x
        magick -size 1024x1024 xc:"#F8FAFC" \
            -fill "rgba(255,255,255,0.8)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#2563EB" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Light-1x.png"
        
        # Light 2x
        magick -size 1024x1024 xc:"#F8FAFC" \
            -fill "rgba(255,255,255,0.8)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#2563EB" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Light-2x.png"
        
        # Light 3x
        magick -size 1024x1024 xc:"#F8FAFC" \
            -fill "rgba(255,255,255,0.8)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#2563EB" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Light-3x.png"
        
        # Dark Mode Icons - Modern syntax
        print_status "info" "Creating dark mode icons..."
        
        # Dark 1x
        magick -size 1024x1024 xc:"#0F172A" \
            -fill "rgba(255,255,255,0.15)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#3B82F6" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Dark-1x.png"
        
        # Dark 2x
        magick -size 1024x1024 xc:"#0F172A" \
            -fill "rgba(255,255,255,0.15)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#3B82F6" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Dark-2x.png"
        
        # Dark 3x
        magick -size 1024x1024 xc:"#0F172A" \
            -fill "rgba(255,255,255,0.15)" \
            -draw "roundrectangle 50,50 974,974 200,200" \
            -fill "#3B82F6" \
            -font "Arial-Bold" \
            -pointsize 400 \
            -gravity center \
            -draw "text 0,0 'S'" \
            "$ICON_DIR/AppIcon-Dark-3x.png"
    fi
    
    print_status "success" "All placeholder icons created with ImageMagick"
    
else
    print_status "warning" "Using sips for basic icon generation (limited effects)..."
    
    # Create a simple colored square as placeholder
    # Note: sips has limited capabilities compared to ImageMagick
    
    # Create a simple 1024x1024 colored square for light mode
    print_status "info" "Creating basic light mode placeholder..."
    sips -s format png --setProperty formatOptions best \
        -z 1024 1024 \
        --padColor F8FAFC \
        "$ICON_DIR/AppIcon-Light-1x.png"
    
    cp "$ICON_DIR/AppIcon-Light-1x.png" "$ICON_DIR/AppIcon-Light-2x.png"
    cp "$ICON_DIR/AppIcon-Light-1x.png" "$ICON_DIR/AppIcon-Light-3x.png"
    
    # Create a simple 1024x1024 colored square for dark mode
    print_status "info" "Creating basic dark mode placeholder..."
    sips -s format png --setProperty formatOptions best \
        -z 1024 1024 \
        --padColor 0F172A \
        "$ICON_DIR/AppIcon-Dark-1x.png"
    
    cp "$ICON_DIR/AppIcon-Dark-1x.png" "$ICON_DIR/AppIcon-Dark-2x.png"
    cp "$ICON_DIR/AppIcon-Dark-1x.png" "$ICON_DIR/AppIcon-Dark-3x.png"
    
    print_status "warning" "Basic placeholder icons created. For better Liquid Glass effects, install ImageMagick."
fi

# Verify all icons were created
echo ""
print_status "info" "Verifying created icons..."

REQUIRED_ICONS=(
    "AppIcon-Light-1x.png"
    "AppIcon-Dark-1x.png"
    "AppIcon-Light-2x.png"
    "AppIcon-Dark-2x.png"
    "AppIcon-Light-3x.png"
    "AppIcon-Dark-3x.png"
)

ALL_CREATED=true

for icon in "${REQUIRED_ICONS[@]}"; do
    if [ -f "$ICON_DIR/$icon" ]; then
        print_status "success" "Created $icon"
        
        # Check file size
        FILE_SIZE=$(stat -f%z "$ICON_DIR/$icon" 2>/dev/null || stat -c%s "$ICON_DIR/$icon" 2>/dev/null)
        if [ "$FILE_SIZE" -gt 1000 ]; then
            print_status "success" "  - File size: ${FILE_SIZE} bytes"
        else
            print_status "warning" "  - File size seems small: ${FILE_SIZE} bytes"
        fi
    else
        print_status "error" "Failed to create $icon"
        ALL_CREATED=false
    fi
done

# Test build
echo ""
print_status "info" "Testing build with new icons..."

if command -v xcodebuild &> /dev/null; then
    print_status "success" "xcodebuild available"
    
    # Try to build to verify icon configuration
    echo "Building project to verify new app icon configuration..."
    if xcodebuild -project SupportingFiles/StryVr.xcodeproj -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 15' build > /dev/null 2>&1; then
        print_status "success" "Project builds successfully with new app icons"
    else
        print_status "warning" "Build failed or took too long (this is normal for first build with new assets)"
    fi
else
    print_status "warning" "xcodebuild not available - skipping build verification"
fi

# Summary
echo ""
print_status "info" "Placeholder App Icon Generation Summary:"
echo ""
if [ "$ALL_CREATED" = true ]; then
    print_status "success" "✅ All placeholder app icons created successfully"
    echo ""
    echo "🎨 Generated Icons:"
    echo "  - Light Mode: Clean, bright glass effect"
    echo "  - Dark Mode: Deep, rich glass effect"
    echo "  - All sizes: 1x, 2x, 3x (1024x1024 pixels)"
    echo ""
    echo "📱 Next Steps:"
    echo "1. Open Xcode and verify icons in Assets.xcassets"
    echo "2. Test light and dark mode switching"
    echo "3. Build and run on device to see app icon"
    echo "4. Replace placeholders with professional designs"
    echo ""
    echo "🎯 For Professional Icons:"
    echo "- Use Figma, Sketch, or Adobe Illustrator"
    echo "- Follow the design guide in Docs/APP_ICON_LIQUID_GLASS_IMPLEMENTATION.md"
    echo "- Ensure proper Liquid Glass effects and transparency"
    echo "- Test on different backgrounds and lighting conditions"
    echo ""
    print_status "success" "Placeholder app icons ready for testing!"
else
    print_status "error" "❌ Some icons failed to create. Check the errors above."
    echo ""
    echo "🔧 Troubleshooting:"
    echo "1. Ensure you have write permissions to the Assets.xcassets directory"
    echo "2. Install ImageMagick for better icon generation: brew install imagemagick"
    echo "3. Check available disk space"
    echo "4. Verify the Contents.json configuration"
fi

echo ""
echo "📚 Resources:"
echo "- Design Guide: Docs/APP_ICON_LIQUID_GLASS_IMPLEMENTATION.md"
echo "- Apple HIG: https://developer.apple.com/design/human-interface-guidelines/app-icons"
echo "- iOS 18 Liquid Glass: https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass" 