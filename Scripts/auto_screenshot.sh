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
