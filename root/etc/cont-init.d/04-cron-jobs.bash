#!/usr/bin/with-contenv bash
echo "Scheduling cron jobs..."

# stop cron
service cron stop

# add script start job
if grep "lidarr-automated-downloader-start.bash" /etc/crontab | read; then
	sleep 0.1
else
	echo "*/15 * * * *   root   bash /config/scripts/lidarr-automated-downloader-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab"
fi

# add download log cleanup job
if grep "download.log" /etc/crontab | read; then
	sleep 0.1
else
	echo "0 0 * * SAT   root   rm \"/config/scripts/lidarr-automated-downloader/download.log\""  >> "/etc/crontab"
fi

# start cron
service cron start

echo "Complete..."
exit 0
