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

# Delete existing config file to update from settings
if [ -f "/lad-config" ]; then
	rm "/lad-config"
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

touch "/lad-config"
echo 'LidarrApiKey="$(grep "<ApiKey>" /config/config.xml | sed "s/\  <ApiKey>//;s/<\/ApiKey>//")"' >> "/lad-config"
echo "downloadmethod=\"$downloadmethod\"" >> "/lad-config"
echo "enablefallback=\"$enablefallback\"" >> "/lad-config"
echo "VerifyTrackCount=\"$VerifyTrackCount\"" >> "/lad-config"
echo "albumtimeoutpercentage=$albumtimeoutpercentage" >> "/lad-config"
echo "tracktimeoutpercentage=$tracktimeoutpercentage" >> "/lad-config"
echo "ReplaygainTagging=\"$ReplaygainTagging\"" >> "/lad-config"
echo "FilePermissions=\"$FilePermissions\"" >> "/lad-config"
echo "FolderPermissions=\"$FolderPermissions\"" >> "/lad-config"
echo "amount=\"$amount\"" >> "/lad-config"
echo "quality=\"$quality\"" >> "/lad-config"
echo "ConversionBitrate=\"$ConversionBitrate\"" >> "/lad-config"
echo "deezloaderurl=\"$deezloaderurl\"" >> "/lad-config"
echo "LidarrUrl=\"$LidarrUrl\"" >> "/lad-config"
echo "LidarrImportLocation=\"$LidarrImportLocation\"" >> "/lad-config"
echo "downloaddir=\"$downloaddir\"" >> "/lad-config"
echo "DownLoadArtistArtwork=\"$DownLoadArtistArtwork\"" >> "/lad-config"

# Modify script with config location
sed -i "s/source .\/config/source \/lad-config/g" "/config/scripts/lidarr-automated-downloader.bash"

# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;

echo "Complete..."

# start cron
service cron start

exit 0
