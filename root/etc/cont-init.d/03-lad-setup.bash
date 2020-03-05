#!/usr/bin/with-contenv bash

echo "Updating LAD scripts..."

# Remove legacy LAD directory
if [ -d /config/scripts/lidarr-automated-downloader ]; then
	rm -rf "/config/scripts/lidarr-automated-downloader"
fi

# Remove legacy lock directory
if [ -d /config/scripts/00-lidarr-automated-downloader.exclusivelock ]; then
	rmdir /config/scripts/00-lidarr-automated-downloader.exclusivelock
fi

# create scripts directory if missing
if [ ! -d "/config/scripts" ]; then
	mkdir -p  "/config/scripts"
fi

# Remove existing LAD start script
if [ -f "/config/scripts/lad-start.bash" ]; then
	rm "/config/scripts/lad-start.bash"
fi

# Copy LAD into scripts start directory
if [ ! -f "/config/scripts/lad-start.bash" ]; then
	cp "/scripts/lad-start.bash" "/config/scripts/lad-start.bash"
fi

# Remove existing LAD script
if [ -f "/config/scripts/lidarr-automated-downloader.bash" ]; then
	rm "/config/scripts/lidarr-automated-downloader.bash"
fi

# Copy LAD into scripts directory
if [ ! -f "/config/scripts/lidarr-automated-downloader.bash" ]; then
	cp "/root/scripts/lidarr-automated-downloader.bash" "/config/scripts/lidarr-automated-downloader.bash"
fi

# Remove lock file incase, system was rebooted before script finished
if [ -d "/config/scripts/00-lad-start.exclusivelock" ]; then
	rmdir "/config/scripts/00-lad-start.exclusivelock"
fi

# Delete existing config file to update from settings
if [ -f "/config/scripts/config" ]; then
	rm "/config/scripts/config"
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
if [ -z "$DownLoadArtistArtwork" ]; then
	DownLoadArtistArtwork="false"
fi

touch "/config/scripts/config"
echo 'LidarrApiKey="$(grep "<ApiKey>" /config/config.xml | sed "s/\  <ApiKey>//;s/<\/ApiKey>//")"' >> "/config/scripts/config"
echo "downloadmethod=\"$downloadmethod\"" >> "/config/scripts/config"
echo "enablefallback=\"$enablefallback\"" >> "/config/scripts/config"
echo "VerifyTrackCount=\"$VerifyTrackCount\"" >> "/config/scripts/config"
echo "dlcheck=$dlcheck" >> "/config/scripts/config"
echo "albumtimeoutpercentage=$albumtimeoutpercentage" >> "/config/scripts/config"
echo "tracktimeoutpercentage=$tracktimeoutpercentage" >> "/config/scripts/config"
echo "ReplaygainTagging=\"$ReplaygainTagging\"" >> "/config/scripts/config"
echo "FilePermissions=\"$FilePermissions\"" >> "/config/scripts/config"
echo "FolderPermissions=\"$FolderPermissions\"" >> "/config/scripts/config"
echo "amount=\"$amount\"" >> "/config/scripts/config"
echo "quality=\"$quality\"" >> "/config/scripts/config"
echo "ConversionBitrate=\"$ConversionBitrate\"" >> "/config/scripts/config"
echo "deezloaderurl=\"$deezloaderurl\"" >> "/config/scripts/config"
echo "LidarrUrl=\"$LidarrUrl\"" >> "/config/scripts/config"
echo "LidarrImportLocation=\"$LidarrImportLocation\"" >> "/config/scripts/config"
echo "downloaddir=\"$downloaddir\"" >> "/config/scripts/config"
echo "DownLoadArtistArtwork=\"$DownLoadArtistArtwork\"" >> "/config/scripts/config"

# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;

# start cron
service cron start

echo "Complete..."
exit 0
