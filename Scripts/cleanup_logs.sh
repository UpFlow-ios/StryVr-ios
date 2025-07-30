#!/bin/bash
# Cleanup old log files (keep last 7 days)
find "$(dirname "$0")/../Logs" -name "*.log" -mtime +7 -delete
find "$(dirname "$0")/../Logs" -name "monitor_*.log" -mtime +30 -delete
