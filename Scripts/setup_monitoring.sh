#!/bin/bash

# Setup Automated Monitoring for StryVr Project
# This script sets up cron jobs for regular project monitoring

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONITOR_SCRIPT="$PROJECT_ROOT/Scripts/monitor_project.sh"
CRON_LOG="$PROJECT_ROOT/Logs/cron.log"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Setting up Automated Monitoring for StryVr ===${NC}"

# Create log directory
mkdir -p "$PROJECT_ROOT/Logs"

# Check if monitor script exists
if [ ! -f "$MONITOR_SCRIPT" ]; then
    echo -e "${YELLOW}Error: Monitor script not found at $MONITOR_SCRIPT${NC}"
    exit 1
fi

# Make sure monitor script is executable
chmod +x "$MONITOR_SCRIPT"

# Create cron job entries
echo -e "${BLUE}Creating cron job entries...${NC}"

# Function to add cron job
add_cron_job() {
    local schedule="$1"
    local description="$2"
    local command="$3"
    
    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -q "$command"; then
        echo -e "${YELLOW}Cron job for $description already exists${NC}"
    else
        # Add to crontab
        (crontab -l 2>/dev/null; echo "$schedule $command") | crontab -
        echo -e "${GREEN}Added cron job for $description${NC}"
    fi
}

# Add monitoring jobs
add_cron_job "0 */6 * * *" "6-hour monitoring" "$MONITOR_SCRIPT >> $CRON_LOG 2>&1"
add_cron_job "0 9 * * *" "daily morning check" "$MONITOR_SCRIPT >> $CRON_LOG 2>&1"
add_cron_job "0 18 * * *" "daily evening check" "$MONITOR_SCRIPT >> $CRON_LOG 2>&1"

# Create a weekly cleanup job
CLEANUP_SCRIPT="$PROJECT_ROOT/Scripts/cleanup_logs.sh"
cat > "$CLEANUP_SCRIPT" << 'EOF'
#!/bin/bash
# Cleanup old log files (keep last 7 days)
find "$(dirname "$0")/../Logs" -name "*.log" -mtime +7 -delete
find "$(dirname "$0")/../Logs" -name "monitor_*.log" -mtime +30 -delete
EOF

chmod +x "$CLEANUP_SCRIPT"
add_cron_job "0 2 * * 0" "weekly log cleanup" "$CLEANUP_SCRIPT >> $CRON_LOG 2>&1"

# Create monitoring dashboard script
DASHBOARD_SCRIPT="$PROJECT_ROOT/Scripts/monitoring_dashboard.sh"
cat > "$DASHBOARD_SCRIPT" << 'EOF'
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
EOF

chmod +x "$DASHBOARD_SCRIPT"

# Create email alert script
ALERT_SCRIPT="$PROJECT_ROOT/Scripts/send_alert.sh"
cat > "$ALERT_SCRIPT" << 'EOF'
#!/bin/bash

# Send monitoring alerts via email

ALERT_EMAIL="joedormond@stryvr.app"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ "$1" = "error" ]; then
    subject="🚨 StryVr Project Alert: Critical Issues Detected"
    priority="high"
elif [ "$1" = "warning" ]; then
    subject="⚠️ StryVr Project Alert: Warnings Detected"
    priority="normal"
else
    subject="ℹ️ StryVr Project Status Update"
    priority="low"
fi

# Create email body
cat > /tmp/stryvr_alert.txt << EMAIL_BODY
StryVr Project Monitoring Alert

Time: $(date)
Project: $(basename "$PROJECT_ROOT")

$(cat)

For detailed analysis, run:
cd "$PROJECT_ROOT"
./Scripts/monitor_project.sh

---
Sent by StryVr Automated Monitoring System
EMAIL_BODY

# Send email (requires mail command)
if command -v mail >/dev/null 2>&1; then
    mail -s "$subject" "$ALERT_EMAIL" < /tmp/stryvr_alert.txt
    echo "Alert sent to $ALERT_EMAIL"
else
    echo "Mail command not available. Alert content:"
    cat /tmp/stryvr_alert.txt
fi

rm -f /tmp/stryvr_alert.txt
EOF

chmod +x "$ALERT_SCRIPT"

echo -e "${GREEN}=== Monitoring Setup Complete ===${NC}"
echo ""
echo -e "${BLUE}Installed monitoring components:${NC}"
echo "  ✓ Monitor script: $MONITOR_SCRIPT"
echo "  ✓ Dashboard script: $DASHBOARD_SCRIPT"
echo "  ✓ Cleanup script: $CLEANUP_SCRIPT"
echo "  ✓ Alert script: $ALERT_SCRIPT"
echo ""
echo -e "${BLUE}Cron jobs added:${NC}"
echo "  • Every 6 hours: Full project monitoring"
echo "  • Daily 9 AM: Morning health check"
echo "  • Daily 6 PM: Evening health check"
echo "  • Weekly Sunday 2 AM: Log cleanup"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo "  • Quick status: ./Scripts/monitoring_dashboard.sh"
echo "  • Full check: ./Scripts/monitor_project.sh"
echo "  • View logs: tail -f $CRON_LOG"
echo ""
echo -e "${YELLOW}Note: Make sure cron is enabled on your system${NC}" 