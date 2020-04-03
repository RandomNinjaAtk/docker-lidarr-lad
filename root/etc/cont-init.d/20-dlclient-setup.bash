#!/usr/bin/with-contenv bash

# create downloads directory
if [ ! -d "/storage/downloads/lidarr/deezloaderremix" ]; then
	mkdir -p "/storage/downloads/lidarr/deezloaderremix"
	chmod 0777 "/storage/downloads/lidarr/deezloaderremix"
fi

if [[ ! -L "/root/Deezloader Music" && ! -d "/root/Deezloader Music" ]]; then
        ln -sf "/storage/downloads/lidarr/deezloaderremix" "/root/Deezloader Music"
fi

# permissions
chown -R abc:abc \
	/xdg/
	
chown -R abc:abc \
	/deezloaderremix/

chmod 0777 -R /deezloaderremix

chown abc:abc \
	/storage/downloads/lidarr/deezloaderremix

chmod 0777 "/storage/downloads/lidarr/deezloaderremix"
chmod 0777 -R "/root"

exit $?
