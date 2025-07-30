#!/bin/bash
# Auto-documentation script

echo "📚 Auto-generating documentation..."

# Update README.md with current status
echo "Updating README.md..."

# Get current git status
GIT_STATUS=$(git status --porcelain | wc -l)
if [ "$GIT_STATUS" -eq 0 ]; then
    REPO_STATUS="Clean"
else
    REPO_STATUS="Dirty ($GIT_STATUS changes)"
fi

# Update README.md with current status
sed -i '' "s/Status.*$/Status: $REPO_STATUS/" README.md 2>/dev/null

echo "✅ Documentation updated"
