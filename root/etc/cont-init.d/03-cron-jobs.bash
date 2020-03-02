#!/bin/bash
echo "==========start cron job setup==========="

# stop cron
service cron stop

# add script start job
if grep "lidarr-automated-downloader-start.bash" /etc/crontab | read; then
	echo "Script start cron job already added..."
else
	echo "Adding script start cron job to crontab..."
	echo "*/15 * * * *   root   bash /config/scripts/lidarr-automated-downloader-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab"
fi

# add download log cleanup job
if grep "download.log" /etc/crontab | read; then
	echo "Download log cleaner cron job already added..."
else
	echo "Adding download log cleaner cron job to crontab..."
	echo "0 0 * * SAT   root   rm \"/config/scripts/lidarr-automated-downloader/download.log\""  >> "/etc/crontab"
fi

# start cron
service cron start

echo "==========end cron job setup==========="
exit 0
