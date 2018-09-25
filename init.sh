#!/bin/bash
# export cronSchedule to file
echo "$CRON_SCHEDULE" > etc/cron.d/cronSchedule && chmod 644 etc/cron.d/cronSchedule
echo "Starting service..." >> /var/log/r.log

/etc/init.d/cron start 2>&1 /var/log/r.log

env > /vars
echo "Exported variables to /vars" >> /var/log/r.log

tailf /var/log/r.log
