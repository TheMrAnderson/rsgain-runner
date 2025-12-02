#!/bin/bash

# Create log file
touch /var/log/rsgain.log

# Set up cron job with output to log file
echo "$SCHEDULE /usr/local/bin/run_rsgain.sh >> /var/log/rsgain.log 2>&1" | crontab -

# Start cron in background
cron

# Tail the log file in foreground for real-time logs
tail -f /var/log/rsgain.log