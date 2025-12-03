#!/bin/bash

# Create log file
touch /var/log/rsgain.log

# Debug: log all env vars
env | grep -E 'MODE|OPTIONS|SCHEDULE' >> /var/log/rsgain.log

# Log configuration for verification
{
    echo "=== rsgain-runner startup at $(date) ==="
    echo "MODE: '$MODE'"
    echo "OPTIONS: '$OPTIONS'"
    echo "SCHEDULE: '$SCHEDULE'"
    echo "Cron job configured and ready."
    echo "=============================="
} >> /var/log/rsgain.log

# Set up cron job with output to log file
echo "$SCHEDULE MODE=\"$MODE\" OPTIONS=\"$OPTIONS\" /usr/local/bin/run_rsgain.sh >> /var/log/rsgain.log 2>&1" | crontab -

# Run initial scan on startup
/usr/local/bin/run_rsgain.sh >> /var/log/rsgain.log 2>&1

# Start cron in background
cron

# Output existing log content and follow new lines
cat /var/log/rsgain.log
tail -f /var/log/rsgain.log