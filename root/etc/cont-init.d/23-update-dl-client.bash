#!/usr/bin/with-contenv bash

# update from git
if [[ "${UPDATE_DLCLIENT}" == "TRUE" ]]; then
    git -C ${PathToDLClient} reset --hard HEAD && \
    git -C ${PathToDLClient} pull origin master
fi

exit 0
