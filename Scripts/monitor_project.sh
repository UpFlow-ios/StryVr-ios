#!/bin/bash

# StryVr Project Monitoring Script
# Automated monitoring for build status, dependencies, security, and performance

set -e

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/Logs"
MONITOR_LOG="$LOG_DIR/monitor_$(date +%Y-%m-%d_%H-%M-%S).log"
ALERT_EMAIL="joedormond@stryvr.app"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$MONITOR_LOG"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$MONITOR_LOG"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$MONITOR_LOG"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$MONITOR_LOG"
}

# Header
log "=== StryVr Project Monitoring Started ==="
log "Project Root: $PROJECT_ROOT"
log "Monitor Log: $MONITOR_LOG"

# 1. Check Git Status
log "--- Checking Git Status ---"
cd "$PROJECT_ROOT"
if git diff --quiet && git diff --cached --quiet; then
    log_success "Working directory is clean"
else
    log_warning "Uncommitted changes detected"
    git status --porcelain | while read line; do
        log "  $line"
    done
fi

# Check for unpushed commits
UNPUSHED=$(git log --oneline origin/main..HEAD | wc -l)
if [ "$UNPUSHED" -gt 0 ]; then
    log_warning "$UNPUSHED unpushed commits detected"
else
    log_success "All commits are pushed"
fi

# 2. Check Dependencies
log "--- Checking Dependencies ---"

# Check Swift Package Manager
if [ -f "Package.swift" ]; then
    log "Checking Swift Package Manager dependencies..."
    if swift package resolve >/dev/null 2>&1; then
        log_success "Swift Package Manager dependencies resolved successfully"
    else
        log_error "Swift Package Manager dependency resolution failed"
    fi
fi

# Check Node.js dependencies
if [ -f "package.json" ]; then
    log "Checking Node.js dependencies..."
    if npm audit --audit-level=moderate >/dev/null 2>&1; then
        log_success "Node.js dependencies are secure"
    else
        log_warning "Node.js security vulnerabilities detected"
        npm audit --audit-level=moderate 2>&1 | head -10 >> "$MONITOR_LOG"
    fi
fi

# 3. Check Build Status
log "--- Checking Build Status ---"

# Check if Xcode project exists
if [ -d "StryVr.xcodeproj" ] || [ -d "StryVr.xcworkspace" ]; then
    log "Xcode project found, checking build configuration..."
    
    # Check for common build issues
    if [ -f "StryVr/GoogleService-Info.plist" ]; then
        log_success "Firebase configuration found"
    else
        log_error "Firebase configuration missing"
    fi
    
    if [ -d "StryVr/Analytics" ]; then
        log_success "Analytics directory exists"
    else
        log_warning "Analytics directory missing"
    fi
fi

# 4. Check File System Health
log "--- Checking File System Health ---"

# Check for large files
log "Checking for large files (>10MB)..."
find "$PROJECT_ROOT" -type f -size +10M -not -path "*/\.*" -not -path "*/node_modules/*" -not -path "*/.build/*" | while read file; do
    size=$(du -h "$file" | cut -f1)
    log_warning "Large file detected: $file ($size)"
done

# Check for temporary files
log "Checking for temporary files..."
find "$PROJECT_ROOT" -name "*.tmp" -o -name "*.temp" -o -name "*~" -not -path "*/\.*" | while read file; do
    log_warning "Temporary file found: $file"
done

# 5. Check Security
log "--- Checking Security ---"

# Check for hardcoded secrets
log "Checking for potential hardcoded secrets..."
grep -r -i "password\|secret\|key\|token" "$PROJECT_ROOT" --exclude-dir={.git,node_modules,.build,.swiftpm} --exclude="*.log" | grep -v "//" | head -5 | while read line; do
    log_warning "Potential secret found: $line"
done

# Check file permissions
log "Checking file permissions..."
find "$PROJECT_ROOT" -type f -perm /111 -name "*.sh" | while read file; do
    if [ ! -x "$file" ]; then
        log_warning "Script file not executable: $file"
    fi
done

# 6. Check Performance Metrics
log "--- Checking Performance Metrics ---"

# Check disk usage
DISK_USAGE=$(du -sh "$PROJECT_ROOT" | cut -f1)
log "Project disk usage: $DISK_USAGE"

# Check number of files
FILE_COUNT=$(find "$PROJECT_ROOT" -type f -not -path "*/\.*" -not -path "*/node_modules/*" | wc -l)
log "Total files in project: $FILE_COUNT"

# 7. Check External Services
log "--- Checking External Services ---"

# Check if Firebase is accessible
if command -v curl >/dev/null 2>&1; then
    if curl -s --connect-timeout 5 https://firebase.google.com >/dev/null 2>&1; then
        log_success "Firebase services accessible"
    else
        log_warning "Firebase services may be down"
    fi
fi

# 8. Generate Summary Report
log "--- Generating Summary Report ---"

# Count issues
ERRORS=$(grep -c "\[ERROR\]" "$MONITOR_LOG" || echo "0")
WARNINGS=$(grep -c "\[WARNING\]" "$MONITOR_LOG" || echo "0")
SUCCESSES=$(grep -c "\[SUCCESS\]" "$MONITOR_LOG" || echo "0")

log "=== Monitoring Summary ==="
log "Errors: $ERRORS"
log "Warnings: $WARNINGS"
log "Successes: $SUCCESSES"

if [ "$ERRORS" -gt 0 ]; then
    log_error "Critical issues detected - immediate attention required"
    exit 1
elif [ "$WARNINGS" -gt 5 ]; then
    log_warning "Multiple warnings detected - review recommended"
    exit 2
else
    log_success "Project health check passed"
    exit 0
fi 