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
