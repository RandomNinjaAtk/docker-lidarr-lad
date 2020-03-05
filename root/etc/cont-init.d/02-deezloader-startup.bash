#!/usr/bin/with-contenv bash

# remove old config
if [ -f "/config/xdg/Deezloader Remix/config.json" ]; then
	rm "/config/xdg/Deezloader Remix/config.json"
	sleep 0.1
fi

# clean log folder
if [ -d "/config/xdg/Deezloader Remix/logs" ]; then
	rm "/config/xdg/Deezloader Remix/logs"/*
	sleep 0.1
fi

# create downloads directory
if [ ! -d "/downloads/deezloaderremix" ]; then
	mkdir "/downloads/deezloaderremix"
	chmod 0777 "/downloads/deezloaderremix"
fi

ln -sf /downloads/deezloaderremix "/root/Deezloader Music" && \

# Start Deezloader
echo "Starting Deezloader Remix..." && \
nohup node /deezloaderremix/app/app.js &>/dev/null &
echo "Startup complete..."

exit 0
