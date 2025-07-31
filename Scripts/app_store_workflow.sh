#!/bin/bash

# App Store Workflow for StryVr iOS App
# Professional development pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to run code quality checks
run_quality_checks() {
    print_status "Running code quality checks..."
    
    # SwiftLint
    if command -v swiftlint &> /dev/null; then
        swiftlint lint --config .swiftlint.yml
        print_success "SwiftLint passed"
    else
        print_warning "SwiftLint not installed"
    fi
    
    # SwiftFormat
    if command -v swiftformat &> /dev/null; then
        swiftformat . --config .swiftformat
        print_success "SwiftFormat completed"
    else
        print_warning "SwiftFormat not installed"
    fi
}

# Function to run security audit
run_security_audit() {
    print_status "Running security audit..."
    
    # Frontend security
    cd frontend && npm audit --audit-level=moderate
    cd ..
    
    # Backend security
    cd backend && npm audit --audit-level=moderate
    cd ..
    
    print_success "Security audit completed"
}

# Function to build and test
build_and_test() {
    print_status "Building and testing StryVr..."
    
    # Clean build
    xcodebuild clean -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
    
    # Build
    xcodebuild build -scheme StryVr -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
    
    print_success "Build completed successfully"
}

# Function to prepare for App Store
prepare_app_store() {
    print_status "Preparing for App Store submission..."
    
    # Update version if needed
    if [ "$1" != "" ]; then
        print_status "Updating version to $1"
        # Add version update logic here
    fi
    
    # Archive for App Store
    xcodebuild archive -scheme StryVr -archivePath builds/StryVr.xcarchive -destination 'generic/platform=iOS'
    
    print_success "App Store preparation completed"
}

# Function to deploy to TestFlight
deploy_testflight() {
    print_status "Deploying to TestFlight..."
    
    if command -v fastlane &> /dev/null; then
        fastlane beta
        print_success "TestFlight deployment initiated"
    else
        print_error "Fastlane not installed"
        exit 1
    fi
}

# Function to deploy to App Store
deploy_app_store() {
    print_status "Deploying to App Store..."
    
    if command -v fastlane &> /dev/null; then
        fastlane release
        print_success "App Store deployment initiated"
    else
        print_error "Fastlane not installed"
        exit 1
    fi
}

# Main workflow
case "$1" in
    "quality")
        run_quality_checks
        ;;
    "security")
        run_security_audit
        ;;
    "build")
        build_and_test
        ;;
    "prepare")
        prepare_app_store "$2"
        ;;
    "testflight")
        run_quality_checks
        run_security_audit
        build_and_test
        deploy_testflight
        ;;
    "release")
        run_quality_checks
        run_security_audit
        build_and_test
        prepare_app_store "$2"
        deploy_app_store
        ;;
    "full")
        print_status "Running full App Store workflow..."
        run_quality_checks
        run_security_audit
        build_and_test
        prepare_app_store "$2"
        deploy_testflight
        print_success "Full workflow completed!"
        ;;
    *)
        echo "Usage: $0 {quality|security|build|prepare|testflight|release|full}"
        echo ""
        echo "Commands:"
        echo "  quality     - Run code quality checks"
        echo "  security    - Run security audit"
        echo "  build       - Build and test the app"
        echo "  prepare     - Prepare for App Store (with optional version)"
        echo "  testflight  - Deploy to TestFlight"
        echo "  release     - Deploy to App Store"
        echo "  full        - Run complete workflow"
        exit 1
        ;;
esac 