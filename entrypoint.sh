#!/bin/bash

# Create log file
touch /var/log/rsgain.log

# Log configuration for verification
{
    echo "=== rsgain-runner startup ==="
    echo "MODE: $MODE"
    echo "OPTIONS: $OPTIONS"
    echo "SCHEDULE: $SCHEDULE"
    echo "Cron job configured and ready."
    echo "=============================="
} >> /var/log/rsgain.log

# Set up cron job with output to log file
echo "$SCHEDULE MODE=\"$MODE\" OPTIONS=\"$OPTIONS\" /usr/local/bin/run_rsgain.sh" | crontab -

# Start cron in background
cron

# Tail the log file in foreground for real-time logs
tail -f /var/log/rsgain.log