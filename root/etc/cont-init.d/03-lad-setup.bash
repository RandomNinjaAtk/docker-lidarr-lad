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

# Delete existing config file to update from settings

if [ -f "/config/scripts/lidarr-automated-downloader/config" ]; then
	rm "/config/scripts/lidarr-automated-downloader/config"
	sleep 0.1
fi

# Create config file

if [ -z "$downloadmethod" ]; then
	downloadmethod="album"
fi
if [ -z "$enablefallback" ]; then
	enablefallback="true"
fi
if [ -z "$VerifyTrackCount" ]; then
	VerifyTrackCount="true"
fi
if [ -z "$dlcheck" ]; then
	dlcheck=3
fi
if [ -z "$albumtimeoutpercentage" ]; then
	albumtimeoutpercentage=8
fi
if [ -z "$tracktimeoutpercentage" ]; then
	tracktimeoutpercentage=25
fi
if [ -z "$ReplaygainTagging" ]; then
	ReplaygainTagging="FALSE"
fi
if [ -z "$FilePermissions" ]; then
	FilePermissions="666"
fi
if [ -z "$FolderPermissions" ]; then
	FolderPermissions="777"
fi
if [ -z "$amount" ]; then
	amount="1000000000"
fi
if [ -z "$quality" ]; then
	quality="FLAC"
fi
if [ -z "$ConversionBitrate" ]; then
	ConversionBitrate="320"
fi
if [ -z "$deezloaderurl" ]; then
	deezloaderurl="http://127.0.0.1:1730"
fi
if [ -z "$LidarrUrl" ]; then
	LidarrUrl="http://127.0.0.1:8686"
fi
if [ -z "$LidarrImportLocation" ]; then
	LidarrImportLocation="/downloads/lidarr-import"
fi
if [ -z "$downloaddir" ]; then
	downloaddir="/downloads/deezloaderremix"
fi

touch "/config/scripts/lidarr-automated-downloader/config"
echo 'LidarrApiKey="$(grep "<ApiKey>" /config/config.xml | sed "s/\  <ApiKey>//;s/<\/ApiKey>//")"' >> "/config/scripts/lidarr-automated-downloader/config"
echo "downloadmethod=\"$downloadmethod\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "enablefallback=\"$enablefallback\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "VerifyTrackCount=\"$VerifyTrackCount\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "dlcheck=$dlcheck" >> "/config/scripts/lidarr-automated-downloader/config"
echo "albumtimeoutpercentage=$albumtimeoutpercentage" >> "/config/scripts/lidarr-automated-downloader/config"
echo "tracktimeoutpercentage=$tracktimeoutpercentage" >> "/config/scripts/lidarr-automated-downloader/config"
echo "ReplaygainTagging=\"$ReplaygainTagging\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "FilePermissions=\"$FilePermissions\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "FolderPermissions=\"$FolderPermissions\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "amount=\"$amount\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "quality=\"$quality\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "ConversionBitrate=\"$ConversionBitrate\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "deezloaderurl=\"$deezloaderurl\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "LidarrUrl=\"$LidarrUrl\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "LidarrImportLocation=\"$LidarrImportLocation\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo "downloaddir=\"$downloaddir\"" >> "/config/scripts/lidarr-automated-downloader/config"
echo 'qualitytest=\"$QUALITYTEST\"' >> "/config/scripts/lidarr-automated-downloader/config"


# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;

if [ -d "/config/xdg" ]; then
	chmod 0777 -R /config/xdg
fi

echo "==========end lidarr-automated-downloader setup==========="
exit 0
