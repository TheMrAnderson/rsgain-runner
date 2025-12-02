#!/bin/bash

# Set up cron job
echo "$SCHEDULE /usr/local/bin/run_rsgain.sh" | crontab -

# Run cron in foreground
exec cron -f