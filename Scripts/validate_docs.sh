#!/bin/bash
# Documentation validation script

echo "🔍 Validating documentation..."

# Check for broken links
echo "Checking for broken links..."
BROKEN_LINKS=$(find . -name "*.md" -exec grep -l "\[.*\](.*)" {} \; | xargs grep -o "\[.*\](.*)" | grep -v "http" | wc -l)

if [ "$BROKEN_LINKS" -eq 0 ]; then
    echo "✅ No broken links found"
else
    echo "⚠️ Found $BROKEN_LINKS potential broken links"
fi

# Check for missing documentation
echo "Checking for missing documentation..."
MISSING_DOCS=0

for dir in StryVr/Views StryVr/Models StryVr/Services; do
    if [ -d "$dir" ]; then
        SWIFT_FILES=$(find "$dir" -name "*.swift" | wc -l)
        DOC_FILES=$(find "$dir" -name "*.md" | wc -l)
        if [ "$DOC_FILES" -eq 0 ] && [ "$SWIFT_FILES" -gt 0 ]; then
            echo "⚠️ $dir has Swift files but no documentation"
            ((MISSING_DOCS++))
        fi
    fi
done

if [ "$MISSING_DOCS" -eq 0 ]; then
    echo "✅ All directories have appropriate documentation"
else
    echo "⚠️ $MISSING_DOCS directories need documentation"
fi

echo "✅ Documentation validation completed"
