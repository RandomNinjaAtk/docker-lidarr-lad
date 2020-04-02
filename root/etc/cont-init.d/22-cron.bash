#!/usr/bin/with-contenv bash

# start lad automatically
if [[ "${ENABLE_LAD}" == "TRUE" ]]; then
    service cron start
    echo "Automatic LAD runs eanbled..."
else
  echo "Automatic LAD runs disabled..."
fi

exit $?
