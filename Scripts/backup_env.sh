#!/bin/bash

# StryVr Environment Backup Script
# Automatically creates timestamped backups of .env files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="backend"
ENV_FILE=".env"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE=".env.backup.${TIMESTAMP}"

echo -e "${BLUE}🔐 StryVr Environment Backup${NC}"
echo "=================================="

# Check if .env file exists
if [ ! -f "${BACKUP_DIR}/${ENV_FILE}" ]; then
    echo -e "${RED}❌ Error: ${ENV_FILE} not found in ${BACKUP_DIR}/${NC}"
    exit 1
fi

# Create backup
echo -e "${YELLOW}📁 Creating backup: ${BACKUP_FILE}${NC}"
cp "${BACKUP_DIR}/${ENV_FILE}" "${BACKUP_DIR}/${BACKUP_FILE}"

# Validate backup
if [ -f "${BACKUP_DIR}/${BACKUP_FILE}" ]; then
    echo -e "${GREEN}✅ Backup created successfully${NC}"
    
    # Check file sizes
    ORIGINAL_SIZE=$(wc -c < "${BACKUP_DIR}/${ENV_FILE}")
    BACKUP_SIZE=$(wc -c < "${BACKUP_DIR}/${BACKUP_FILE}")
    
    if [ "$ORIGINAL_SIZE" -eq "$BACKUP_SIZE" ]; then
        echo -e "${GREEN}✅ Backup size matches original${NC}"
    else
        echo -e "${RED}❌ Warning: Backup size mismatch${NC}"
    fi
    
    # Count API keys
    API_KEY_COUNT=$(grep -c "API_KEY" "${BACKUP_DIR}/${BACKUP_FILE}")
    echo -e "${BLUE}🔑 API keys in backup: ${API_KEY_COUNT}${NC}"
    
    # List recent backups
    echo -e "${YELLOW}📋 Recent backups:${NC}"
    ls -la "${BACKUP_DIR}"/.env.backup.* | tail -5
    
else
    echo -e "${RED}❌ Backup failed${NC}"
    exit 1
fi

# Cleanup old backups (keep last 10)
echo -e "${YELLOW}🧹 Cleaning up old backups...${NC}"
BACKUP_COUNT=$(ls "${BACKUP_DIR}"/.env.backup.* 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt 10 ]; then
    OLD_BACKUPS=$(ls -t "${BACKUP_DIR}"/.env.backup.* | tail -n +11)
    for backup in $OLD_BACKUPS; do
        echo "Removing old backup: $(basename "$backup")"
        rm "$backup"
    done
    echo -e "${GREEN}✅ Cleanup completed${NC}"
else
    echo -e "${BLUE}ℹ️  No cleanup needed (${BACKUP_COUNT} backups)${NC}"
fi

echo -e "${GREEN}🎉 Backup process completed successfully!${NC}"
echo -e "${BLUE}📁 Backup location: ${BACKUP_DIR}/${BACKUP_FILE}${NC}" 