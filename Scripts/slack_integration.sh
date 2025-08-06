#!/bin/bash

# Slack Integration Manager for StryVr iOS App
# Professional development team communication and automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[SLACK]${NC} $1"
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

print_section() {
    echo -e "${PURPLE}[SECTION]${NC} $1"
}

# Configuration
SLACK_CONFIG_FILE=".slack_config.json"
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Function to check if Slack webhook URL is configured
check_slack_config() {
    if [ ! -f "$SLACK_CONFIG_FILE" ]; then
        print_warning "Slack configuration not found. Run setup first."
        return 1
    fi
    
    if [ ! -s "$SLACK_CONFIG_FILE" ]; then
        print_warning "Slack configuration file is empty."
        return 1
    fi
    
    return 0
}

# Function to send Slack notification
send_slack_notification() {
    local channel="$1"
    local message="$2"
    local color="$3"
    local webhook_url="$4"
    
    if [ -z "$webhook_url" ]; then
        print_error "Webhook URL not provided"
        return 1
    fi
    
    local payload=$(cat <<EOF
{
    "channel": "#${channel}",
    "username": "StryVr Bot",
    "icon_emoji": ":rocket:",
    "attachments": [
        {
            "color": "${color}",
            "fields": [
                {
                    "title": "StryVr Development Update",
                    "value": "${message}",
                    "short": false
                }
            ],
            "footer": "StryVr iOS App",
            "ts": $(date +%s)
        }
    ]
}
EOF
)
    
    curl -X POST -H 'Content-type: application/json' \
        --data "$payload" \
        "$webhook_url" &>/dev/null
        
    if [ $? -eq 0 ]; then
        print_success "Slack notification sent to #${channel}"
    else
        print_error "Failed to send Slack notification"
    fi
}

# Function to setup Slack configuration
setup_slack_config() {
    print_section "Setting up Slack Integration for StryVr"
    
    echo "📝 Please provide your Slack webhook URLs:"
    echo "   (You can get these from: https://api.slack.com/apps)"
    echo ""
    
    read -p "🔧 CI/CD Channel Webhook URL: " ci_webhook
    read -p "🚀 Deployment Channel Webhook URL: " deploy_webhook
    read -p "🔒 Security Channel Webhook URL: " security_webhook
    read -p "👥 General Development Channel Webhook URL: " general_webhook
    
    # Create configuration file
    cat > "$SLACK_CONFIG_FILE" <<EOF
{
    "webhooks": {
        "ci_cd": "${ci_webhook}",
        "deployment": "${deploy_webhook}",
        "security": "${security_webhook}",
        "general": "${general_webhook}"
    },
    "channels": {
        "ci_cd": "stryvr-ci",
        "deployment": "stryvr-deployment",
        "security": "stryvr-security",
        "general": "stryvr-dev"
    },
    "setup_date": "${CURRENT_DATE}"
}
EOF
    
    print_success "Slack configuration saved to ${SLACK_CONFIG_FILE}"
    print_status "Configuration includes CI/CD, Deployment, Security, and General channels"
}

# Function to send CI/CD notifications
notify_ci_status() {
    local status="$1"
    local details="$2"
    
    if ! check_slack_config; then
        return 1
    fi
    
    local webhook=$(cat "$SLACK_CONFIG_FILE" | grep -o '"ci_cd":"[^"]*"' | cut -d'"' -f4)
    local channel=$(cat "$SLACK_CONFIG_FILE" | grep -o '"ci_cd":"[^"]*"' | cut -d'"' -f4)
    
    case "$status" in
        "success")
            local color="good"
            local emoji="✅"
            ;;
        "failure")
            local color="danger"
            local emoji="❌"
            ;;
        "warning")
            local color="warning"
            local emoji="⚠️"
            ;;
        *)
            local color="#36a64f"
            local emoji="🔄"
            ;;
    esac
    
    local message="${emoji} CI/CD Pipeline ${status^}: ${details}"
    send_slack_notification "$channel" "$message" "$color" "$webhook"
}

# Function to send deployment notifications
notify_deployment() {
    local stage="$1"
    local status="$2"
    local version="$3"
    
    if ! check_slack_config; then
        return 1
    fi
    
    local webhook=$(cat "$SLACK_CONFIG_FILE" | grep -o '"deployment":"[^"]*"' | cut -d'"' -f4)
    local channel=$(cat "$SLACK_CONFIG_FILE" | grep -o '"deployment":"[^"]*"' | cut -d'"' -f4)
    
    local message="🚀 StryVr ${stage} Deployment ${status}: Version ${version}"
    local color="good"
    
    if [ "$status" != "successful" ]; then
        color="danger"
        message="💥 StryVr ${stage} Deployment ${status}: Version ${version}"
    fi
    
    send_slack_notification "$channel" "$message" "$color" "$webhook"
}

# Function to send security notifications
notify_security() {
    local alert_type="$1"
    local severity="$2"
    local details="$3"
    
    if ! check_slack_config; then
        return 1
    fi
    
    local webhook=$(cat "$SLACK_CONFIG_FILE" | grep -o '"security":"[^"]*"' | cut -d'"' -f4)
    local channel=$(cat "$SLACK_CONFIG_FILE" | grep -o '"security":"[^"]*"' | cut -d'"' -f4)
    
    case "$severity" in
        "critical")
            local color="danger"
            local emoji="🚨"
            ;;
        "high")
            local color="warning"
            local emoji="⚠️"
            ;;
        "medium")
            local color="#ffaa00"
            local emoji="🔍"
            ;;
        *)
            local color="good"
            local emoji="🔒"
            ;;
    esac
    
    local message="${emoji} Security Alert (${severity^}): ${alert_type} - ${details}"
    send_slack_notification "$channel" "$message" "$color" "$webhook"
}

# Function to send general development notifications
notify_development() {
    local event="$1"
    local details="$2"
    
    if ! check_slack_config; then
        return 1
    fi
    
    local webhook=$(cat "$SLACK_CONFIG_FILE" | grep -o '"general":"[^"]*"' | cut -d'"' -f4)
    local channel=$(cat "$SLACK_CONFIG_FILE" | grep -o '"general":"[^"]*"' | cut -d'"' -f4)
    
    local message="💻 StryVr Development: ${event} - ${details}"
    send_slack_notification "$channel" "$message" "good" "$webhook"
}

# Function to send App Store notifications
notify_app_store() {
    local milestone="$1"
    local status="$2"
    local details="$3"
    
    if ! check_slack_config; then
        return 1
    fi
    
    local webhook=$(cat "$SLACK_CONFIG_FILE" | grep -o '"deployment":"[^"]*"' | cut -d'"' -f4)
    local channel=$(cat "$SLACK_CONFIG_FILE" | grep -o '"deployment":"[^"]*"' | cut -d'"' -f4)
    
    local color="good"
    local emoji="🏪"
    
    if [ "$status" != "success" ]; then
        color="warning"
        emoji="⚠️"
    fi
    
    local message="${emoji} App Store ${milestone}: ${status} - ${details}"
    send_slack_notification "$channel" "$message" "$color" "$webhook"
}

# Function to test Slack integration
test_slack_integration() {
    print_section "Testing Slack Integration"
    
    if ! check_slack_config; then
        print_error "Slack not configured. Run 'setup' first."
        return 1
    fi
    
    print_status "Sending test notifications..."
    
    notify_ci_status "success" "CI/CD pipeline test notification"
    notify_deployment "TestFlight" "successful" "1.0.0"
    notify_security "Dependency Scan" "low" "All dependencies up to date"
    notify_development "Feature Complete" "New Liquid Glass UI implementation ready"
    notify_app_store "Submission" "success" "StryVr submitted for App Store review"
    
    print_success "Test notifications sent to all configured channels"
}

# Function to show help
show_help() {
    echo "StryVr Slack Integration Manager"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  setup                     - Configure Slack webhooks and channels"
    echo "  test                      - Send test notifications to all channels"
    echo "  ci [status] [details]     - Send CI/CD notification"
    echo "  deploy [stage] [status] [version] - Send deployment notification"
    echo "  security [type] [severity] [details] - Send security notification"
    echo "  dev [event] [details]     - Send development notification"
    echo "  appstore [milestone] [status] [details] - Send App Store notification"
    echo "  status                    - Show current configuration"
    echo ""
    echo "Examples:"
    echo "  $0 ci success 'All tests passed'"
    echo "  $0 deploy TestFlight successful v1.0.0"
    echo "  $0 security 'Vulnerability Found' critical 'CVE-2024-1234 detected'"
    echo "  $0 appstore Submission success 'App submitted for review'"
}

# Function to show status
show_status() {
    print_section "Slack Integration Status"
    
    if check_slack_config; then
        print_success "Configuration found"
        echo ""
        echo "Configured channels:"
        cat "$SLACK_CONFIG_FILE" | grep -A5 '"channels"' | grep -v '{' | grep -v '}' | sed 's/^[ ]*/  /'
        echo ""
        echo "Setup date: $(cat "$SLACK_CONFIG_FILE" | grep 'setup_date' | cut -d'"' -f4)"
    else
        print_warning "Slack integration not configured"
        print_status "Run '$0 setup' to configure Slack integration"
    fi
}

# Main execution
case "${1:-help}" in
    "setup")
        setup_slack_config
        ;;
    "test")
        test_slack_integration
        ;;
    "ci")
        notify_ci_status "$2" "$3"
        ;;
    "deploy")
        notify_deployment "$2" "$3" "$4"
        ;;
    "security")
        notify_security "$2" "$3" "$4"
        ;;
    "dev")
        notify_development "$2" "$3"
        ;;
    "appstore")
        notify_app_store "$2" "$3" "$4"
        ;;
    "status")
        show_status
        ;;
    "help"|*)
        show_help
        ;;
esac

echo ""
print_status "StryVr Slack Integration Manager completed"