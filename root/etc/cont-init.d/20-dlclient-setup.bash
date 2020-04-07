#!/usr/bin/with-contenv bash

# create downloads directory
if [ ! -d "/storage/downloads/lidarr/dlclient" ]; then
	mkdir -p "/storage/downloads/lidarr/dlclient"
	chmod 0777 "/storage/downloads/lidarr/dlclient"
fi

# permissions
chown -R abc:abc \
	/xdg/
	
chown abc:abc \
	/storage/downloads/lidarr/deezloaderremix

chmod 0777 "/storage/downloads/lidarr/deezloaderremix"
chmod 0777 -R "/root"

exit $?
