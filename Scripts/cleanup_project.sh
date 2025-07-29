#!/bin/bash

# StryVr Project Cleanup Script
# Safely removes unnecessary files without affecting the app

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 StryVr Project Cleanup${NC}"
echo "=============================="

# Calculate space before cleanup
echo -e "${YELLOW}📊 Space usage before cleanup:${NC}"
BEFORE_SPACE=$(du -sh . | cut -f1)
echo "Current directory: ${BEFORE_SPACE}"

# Files to remove (safe)
FILES_TO_REMOVE=(
    "build-log.txt"
    "current-build.log" 
    "build.log"
    "server.log"
    "backend/server.log"
    ".txt"
    "current-structure.txt"
    "project-structure.txt"
    "notepad.md"
    "BUILD_FIXES_CHECKLIST.md"
    "BUILD_MANAGEMENT.md"
    "firebase-fix.md"
)

# Remove files
echo -e "${YELLOW}🗑️  Removing unnecessary files...${NC}"
REMOVED_COUNT=0
TOTAL_SPACE_SAVED=0

for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -f "$file" ]; then
        FILE_SIZE=$(du -sh "$file" | cut -f1)
        echo "Removing: $file (${FILE_SIZE})"
        rm "$file"
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    else
        echo -e "${BLUE}ℹ️  File not found: $file${NC}"
    fi
done

# Calculate space after cleanup
echo -e "${YELLOW}📊 Space usage after cleanup:${NC}"
AFTER_SPACE=$(du -sh . | cut -f1)
echo "Current directory: ${AFTER_SPACE}"

# Summary
echo -e "${GREEN}✅ Cleanup completed!${NC}"
echo -e "${BLUE}📁 Files removed: ${REMOVED_COUNT}${NC}"
echo -e "${BLUE}💾 Space saved: ${BEFORE_SPACE} → ${AFTER_SPACE}${NC}"

# Check for any remaining large files
echo -e "${YELLOW}🔍 Checking for other large files...${NC}"
find . -type f -size +10M -not -path "./node_modules/*" -not -path "./.git/*" | head -5

echo -e "${GREEN}🎉 Project cleanup completed successfully!${NC}"
echo -e "${BLUE}💡 Your StryVr app is unaffected and ready to run!${NC}" 