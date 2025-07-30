#!/bin/bash

# StryVr Monitoring Dashboard
# Quick overview of project health

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/Logs"

echo "=== StryVr Project Health Dashboard ==="
echo "Last updated: $(date)"
echo ""

# Recent monitoring results
echo "Recent Monitoring Results:"
if [ -d "$LOG_DIR" ]; then
    ls -t "$LOG_DIR"/monitor_*.log 2>/dev/null | head -3 | while read log; do
        echo "  $(basename "$log"):"
        tail -5 "$log" | grep -E "\[ERROR\]|\[WARNING\]|\[SUCCESS\]" | head -3
    done
else
    echo "  No monitoring logs found"
fi

echo ""
echo "Quick Status Check:"
cd "$PROJECT_ROOT"

# Git status
if git diff --quiet && git diff --cached --quiet; then
    echo "  ✓ Git: Clean working directory"
else
    echo "  ⚠ Git: Uncommitted changes"
fi

# Unpushed commits
UNPUSHED=$(git log --oneline origin/main..HEAD 2>/dev/null | wc -l)
if [ "$UNPUSHED" -eq 0 ]; then
    echo "  ✓ Git: All commits pushed"
else
    echo "  ⚠ Git: $UNPUSHED unpushed commits"
fi

# Build artifacts
if [ -d ".build" ] || [ -d ".swiftpm" ]; then
    echo "  ⚠ Build: Cache directories present"
else
    echo "  ✓ Build: Clean build state"
fi

echo ""
echo "Run './Scripts/monitor_project.sh' for detailed analysis"
