#!/bin/bash

# 🏗️ Xcode Build Manager for StryVr
# Ensures only ONE Xcode build runs at a time across the entire system
# Prevents system slowdown from multiple concurrent builds

set -e

# Configuration
GLOBAL_LOCK_FILE="/tmp/stryvr_global_build.lock"
BUILD_LOCK_FILE="/tmp/stryvr_build.lock"
BUILD_LOG_FILE="current-build.log"
XCODE_PROCESSES=("xcodebuild" "Xcode" "SourceKit-LSP" "clang" "swiftc")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_section() {
    echo -e "${PURPLE}📋 $1${NC}"
    echo "=================================="
}

# Function to check if a process is running
is_process_running() {
    local process_name="$1"
    pgrep -f "$process_name" >/dev/null 2>&1
}

# Function to kill Xcode-related processes
kill_xcode_processes() {
    print_info "Stopping Xcode-related processes..."
    
    for process in "${XCODE_PROCESSES[@]}"; do
        if is_process_running "$process"; then
            print_warning "Killing $process processes..."
            pkill -f "$process" 2>/dev/null || true
            sleep 1
        fi
    done
    
    # Force kill any remaining Xcode processes
    if is_process_running "Xcode"; then
        print_warning "Force killing remaining Xcode processes..."
        pkill -9 -f "Xcode" 2>/dev/null || true
    fi
}

# Function to check global build lock
check_global_lock() {
    if [ -f "$GLOBAL_LOCK_FILE" ]; then
        local pid=$(cat "$GLOBAL_LOCK_FILE" 2>/dev/null || echo "unknown")
        local lock_age=$(($(date +%s) - $(stat -f %m "$GLOBAL_LOCK_FILE" 2>/dev/null || echo 0)))
        
        # If lock is older than 30 minutes, consider it stale
        if [ $lock_age -gt 1800 ]; then
            print_warning "Stale global lock detected (age: ${lock_age}s). Removing..."
            rm -f "$GLOBAL_LOCK_FILE"
        else
            print_error "Global build already in progress by PID: $pid"
            print_error "Lock file: $GLOBAL_LOCK_FILE (age: ${lock_age}s)"
            print_info "If this is incorrect, run: rm $GLOBAL_LOCK_FILE"
            exit 1
        fi
    fi
}

# Function to check local build lock
check_local_lock() {
    if [ -f "$BUILD_LOCK_FILE" ]; then
        local pid=$(cat "$BUILD_LOCK_FILE" 2>/dev/null || echo "unknown")
        local lock_age=$(($(date +%s) - $(stat -f %m "$BUILD_LOCK_FILE" 2>/dev/null || echo 0)))
        
        # If lock is older than 10 minutes, consider it stale
        if [ $lock_age -gt 600 ]; then
            print_warning "Stale local lock detected (age: ${lock_age}s). Removing..."
            rm -f "$BUILD_LOCK_FILE"
        else
            print_error "Local build already in progress by PID: $pid"
            print_error "Lock file: $BUILD_LOCK_FILE (age: ${lock_age}s)"
            print_info "If this is incorrect, run: rm $BUILD_LOCK_FILE"
            exit 1
        fi
    fi
}

# Function to create locks
create_locks() {
    echo $$ > "$GLOBAL_LOCK_FILE"
    echo $$ > "$BUILD_LOCK_FILE"
    print_status "Build locks created (PID: $$)"
}

# Function to cleanup locks
cleanup_locks() {
    rm -f "$GLOBAL_LOCK_FILE"
    rm -f "$BUILD_LOCK_FILE"
    print_status "Build locks removed"
}

# Function to show build status
show_build_status() {
    print_section "Build Status Check"
    
    echo "🔍 Checking for running builds..."
    
    local found_builds=false
    
    for process in "${XCODE_PROCESSES[@]}"; do
        if is_process_running "$process"; then
            local pids=$(pgrep -f "$process" | tr '\n' ' ')
            print_warning "$process is running (PIDs: $pids)"
            found_builds=true
        fi
    done
    
    if [ "$found_builds" = false ]; then
        print_status "No Xcode builds currently running"
    fi
    
    # Check lock files
    if [ -f "$GLOBAL_LOCK_FILE" ]; then
        local pid=$(cat "$GLOBAL_LOCK_FILE" 2>/dev/null || echo "unknown")
        local lock_age=$(($(date +%s) - $(stat -f %m "$GLOBAL_LOCK_FILE" 2>/dev/null || echo 0)))
        print_warning "Global lock exists (PID: $pid, age: ${lock_age}s)"
    else
        print_status "No global lock found"
    fi
    
    if [ -f "$BUILD_LOCK_FILE" ]; then
        local pid=$(cat "$BUILD_LOCK_FILE" 2>/dev/null || echo "unknown")
        local lock_age=$(($(date +%s) - $(stat -f %m "$BUILD_LOCK_FILE" 2>/dev/null || echo 0)))
        print_warning "Local lock exists (PID: $pid, age: ${lock_age}s)"
    else
        print_status "No local lock found"
    fi
}

# Function to force cleanup
force_cleanup() {
    print_section "Force Cleanup"
    
    print_warning "Stopping all Xcode processes..."
    kill_xcode_processes
    
    print_warning "Removing all lock files..."
    rm -f "$GLOBAL_LOCK_FILE"
    rm -f "$BUILD_LOCK_FILE"
    
    print_status "Cleanup completed"
}

# Main execution
main() {
    print_section "Xcode Build Manager"
    
    # Parse command line arguments
    case "${1:-build}" in
        "status")
            show_build_status
            exit 0
            ;;
        "cleanup")
            force_cleanup
            exit 0
            ;;
        "kill")
            kill_xcode_processes
            exit 0
            ;;
        "build")
            # Continue with build process
            ;;
        *)
            echo "Usage: $0 [build|status|cleanup|kill]"
            echo "  build   - Start a new build (default)"
            echo "  status  - Show current build status"
            echo "  cleanup - Force cleanup all locks and processes"
            echo "  kill    - Kill all Xcode processes"
            exit 1
            ;;
    esac
    
    # Check for existing builds
    check_global_lock
    check_local_lock
    
    # Kill any existing Xcode processes
    kill_xcode_processes
    
    # Create locks
    create_locks
    
    # Set up cleanup trap
    trap 'cleanup_locks; print_status "Build completed. Locks removed."' EXIT
    trap 'cleanup_locks; print_error "Build interrupted. Locks removed."' INT TERM
    
    print_section "Starting StryVr Build"
    print_info "Build log: $BUILD_LOG_FILE"
    print_info "Global lock: $GLOBAL_LOCK_FILE"
    print_info "Local lock: $BUILD_LOCK_FILE"
    print_info "PID: $$"
    
    # Run the build
    xcodebuild -project SupportingFiles/StryVr.xcodeproj \
        -scheme StryVr \
        -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.3.1' \
        build 2>&1 | tee "$BUILD_LOG_FILE"
    
    BUILD_EXIT_CODE=${PIPESTATUS[0]}
    
    echo ""
    print_section "Build Results"
    echo "📊 Build completed with exit code: $BUILD_EXIT_CODE"
    
    if [ $BUILD_EXIT_CODE -eq 0 ]; then
        print_status "Build successful!"
    else
        print_error "Build failed. Check $BUILD_LOG_FILE for details."
    fi
    
    exit $BUILD_EXIT_CODE
}

# Run main function
main "$@" 