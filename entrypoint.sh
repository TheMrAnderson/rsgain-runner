#!/bin/bash

# Store environment variables for cron to read
printenv > /etc/environment

# Create log file
touch /var/log/rsgain.log

# Log configuration for verification
{
    echo "=== rsgain-runner startup ==="
    echo "MODE: $MODE"
    echo "OPTIONS: $OPTIONS"
    echo "SCHEDULE: $SCHEDULE"
    echo "Next cron execution: $(date -d "next $SCHEDULE" 2>/dev/null || echo 'Check cron syntax')"
    echo "=============================="
} >> /var/log/rsgain.log

# Set up cron job with output to log file
echo "$SCHEDULE /usr/local/bin/run_rsgain.sh >> /var/log/rsgain.log 2>&1" | crontab -

# Start cron in background
cron

# Tail the log file in foreground for real-time logs
tail -f /var/log/rsgain.log