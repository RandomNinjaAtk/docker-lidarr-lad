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
	mkdir -p "/config/scripts"
fi

# Remove existing LAD start script
if [ -f "/config/scripts/lad-start.bash" ]; then
	rm "/config/scripts/lad-start.bash"
fi

# Remove existing LAD script
if [ -f "/config/scripts/lidarr-automated-downloader.bash" ]; then
	rm "/config/scripts/lidarr-automated-downloader.bash"
	sleep 0.1
fi

# Copy LAD into scripts directory
if [ ! -f "/config/scripts/lidarr-automated-downloader.bash" ]; then
	cp "/root/scripts/lidarr-automated-downloader.bash" "/config/scripts/lidarr-automated-downloader.bash"
fi

# Remove lock file incase, system was rebooted before script finished
if [ -d "/scripts/00-lad-start.exclusivelock" ]; then
	rmdir "/scripts/00-lad-start.exclusivelock"
fi

# Remove legacy lock file incase
if [ -d "/config/scripts/00-lad-start.exclusivelock" ]; then
	rmdir "/config/scripts/00-lad-start.exclusivelock"
fi


# Delete existing config file to update from settings
if [ -f "/config/scripts/config" ]; then
	rm "/config/scripts/config"
	sleep 0.1
fi

# Delete existing config file to update from settings
if [ -f "/scripts/lad-config" ]; then
	rm "/scripts/lad-config"
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
	quality="MP3"
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
	LidarrImportLocation="/storage/downloads/lidarr/lidarr-import"
fi
if [ -z "$downloaddir" ]; then
	downloaddir="/storage/downloads/lidarr/deezloaderremix"
fi
if [ -z "$DownLoadArtistArtwork" ]; then
	DownLoadArtistArtwork="true"
fi

touch "/scripts/lad-config"
echo 'LidarrApiKey="$(grep "<ApiKey>" /config/config.xml | sed "s/\  <ApiKey>//;s/<\/ApiKey>//")"' >> "/scripts/lad-config"
echo "downloadmethod=\"$downloadmethod\"" >> "/scripts/lad-config"
echo "enablefallback=\"$enablefallback\"" >> "/scripts/lad-config"
echo "VerifyTrackCount=\"$VerifyTrackCount\"" >> "/scripts/lad-config"
echo "albumtimeoutpercentage=$albumtimeoutpercentage" >> "/scripts/lad-config"
echo "tracktimeoutpercentage=$tracktimeoutpercentage" >> "/scripts/lad-config"
echo "ReplaygainTagging=\"$ReplaygainTagging\"" >> "/scripts/lad-config"
echo "FilePermissions=\"$FilePermissions\"" >> "/scripts/lad-config"
echo "FolderPermissions=\"$FolderPermissions\"" >> "/scripts/lad-config"
echo "amount=\"$amount\"" >> "/scripts/lad-config"
echo "quality=\"$quality\"" >> "/scripts/lad-config"
echo "ConversionBitrate=\"$ConversionBitrate\"" >> "/scripts/lad-config"
echo "deezloaderurl=\"$deezloaderurl\"" >> "/scripts/lad-config"
echo "LidarrUrl=\"$LidarrUrl\"" >> "/scripts/lad-config"
echo "LidarrImportLocation=\"$LidarrImportLocation\"" >> "/scripts/lad-config"
echo "downloaddir=\"$downloaddir\"" >> "/scripts/lad-config"
echo "DownLoadArtistArtwork=\"$DownLoadArtistArtwork\"" >> "/scripts/lad-config"

# Modify script with config location
sed -i "s/source .\/config/source \/scripts\/lad-config/g" "/config/scripts/lidarr-automated-downloader.bash"

# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;

echo "Complete..."

# start cron
service cron start

exit 0
