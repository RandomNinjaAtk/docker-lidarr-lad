#!/usr/bin/with-contenv bash

# update from git
UPDATE_LAD="TRUE"
if [[ "${UPDATE_LAD}" == "TRUE" ]]; then
    git -C ${LAD_PATH} reset --hard HEAD && \
    git -C ${LAD_PATH} pull origin master
fi
exit 0
