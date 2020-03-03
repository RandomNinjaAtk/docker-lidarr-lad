#!/usr/bin/with-contenv bash

if [ ! -d /downloads/deezloaderremix ]; then
	mkdir /downloads/deezloaderremix
fi

ln -sf /downloads/deezloaderremix "/root/Deezloader Music" && \

# Start Deezloader
echo "Starting Deezloader Remix..." && \
nohup node /deezloaderremix/app/app.js &>/dev/null &
echo "Startup complete..."

exit 0
