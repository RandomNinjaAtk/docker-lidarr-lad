#!/usr/bin/with-contenv bash

# create downloads directory
if [ ! -d "${downloaddir}" ]; then
	mkdir -p "${downloaddir}"
	chmod 0777 "${downloaddir}"
fi

# permissions
chown -R abc:abc "/xdg/"	
chown abc:abc "${downloaddir}"

chmod 0777 "${downloaddir}"
chmod 0777 -R "/root"

exit $?
