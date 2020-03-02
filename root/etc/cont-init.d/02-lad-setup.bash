#!/bin/bash
echo "==========start lidarr-automated-downloader setup==========="

if [ ! -d /config/scripts ]; then
	echo "setting up script directory"
	mkdir -p /config/scripts
	echo "done"
fi

if [ -f /config/scripts/lidarr-download-automation-start.bash ]; then
	rm /config/scripts/lidarr-automated-downloader-start.bash
	sleep 0.1
fi

if [ ! -f /config/scripts/lidarr-download-automation-start.bash ]; then
	echo "downloading lidarr-automated-downloader-start.bash from: https://github.com/RandomNinjaAtk/lidarr-automated-downloader/blob/master/docker/lidarr-automated-downloader-start.bash"
	curl -o "/config/scripts/lidarr-automated-downloader-start.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/docker/lidarr-automated-downloader-start.bash"
	echo "done"
fi

# Remove lock file incase, system was rebooted before script finished
if [ -d /config/scripts/00-lidarr-automated-downloader.exclusivelock ]; then
	rmdir /config/scripts/00-lidarr-automated-downloader.exclusivelock
fi

if [ ! -d /config/scripts/lidarr-automated-downloader ]; then
    echo "setting up script lidarr-automated-downloader directory..."
    mkdir -p /config/scripts/lidarr-automated-downloader
    echo "done"
fi
	
# Download Scripts
if [ -f "/config/scripts/lidarr-automated-downloader/lidarr-automated-downloader.bash" ]; then
	rm /config/scripts/lidarr-automated-downloader/lidarr-automated-downloader.bash
	sleep 0.1
fi

if [ ! -f "/config/scripts/lidarr-automated-downloader/lidarr-automated-downloader.bash" ]; then
    echo "downloading lidarr-automated-downloader.bash from: https://github.com/RandomNinjaAtk/lidarr-automated-downloader/blob/master/lidarr-automated-downloader.bash"
    curl -o "/config/scripts/lidarr-automated-downloader/lidarr-automated-downloader.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/lidarr-automated-downloader.bash"
    echo "done"
fi

# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;

if [ -d "/config/xdg" ]; then
	chmod 0777 -R /config/xdg
fi

echo "==========end lidarr-automated-downloader setup==========="
exit 0
