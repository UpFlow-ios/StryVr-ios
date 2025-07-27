#!/bin/bash

# StryVr Build Status Checker

BUILD_LOCK_FILE="/tmp/stryvr_build.lock"

if [ -f "$BUILD_LOCK_FILE" ]; then
    PID=$(cat "$BUILD_LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "🚫 Build is currently running (PID: $PID)"
        echo "   Lock file: $BUILD_LOCK_FILE"
        echo "   Wait for completion or run: rm $BUILD_LOCK_FILE"
    else
        echo "⚠️  Stale lock file found (PID: $PID not running)"
        echo "   Run: rm $BUILD_LOCK_FILE to clear it"
    fi
else
    echo "✅ No build currently running"
    echo "   Ready to start new build with: ./build-stryvr.sh"
fi 