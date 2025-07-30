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
