#!/bin/bash

if mkdir /scripts/00-lad-start.exclusivelock; then
  
	rm /config/scripts/script-run.log
	cd /config/scripts/
	bash lidarr-automated-downloader.bash 2>&1 | tee "/config/scripts/script-run.log" > /proc/1/fd/1 2>/proc/1/fd/2

	sleep 0.1
	rmdir /scripts/00-lad-start.exclusivelock
	
else
	echo "ERROR: /config/scripts/lidarr-automated-downloader.bash is still running..."
	exit 1
fi
exit 0
