#!/usr/bin/with-contenv bash

echo "Updating LAD scripts..."

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
	cp "${LAD_PATH}/lidarr-automated-downloader.bash" "/config/scripts/lidarr-automated-downloader.bash"
fi

# Copy Beets config into scripts directory
if [ ! -f "/config/scripts/beets-config.yaml" ]; then
	cp "${LAD_PATH}/beets-config.yaml" "/config/scripts/beets-config.yaml"
fi


# Remove lock file incase, system was rebooted before script finished
if [ -d "/scripts/00-lad-start.exclusivelock" ]; then
	rmdir "/scripts/00-lad-start.exclusivelock"
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
if [ -z "$TagWithBeets" ]; then
	TagWithBeets="true"
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
echo "BeetConfig=\"/config/scripts/beets-config.yaml\"" >> "/scripts/lad-config"
echo "BeetLibrary=\"/config/scripts/beets-library.blb\"" >> "/scripts/lad-config"
echo "BeetLog=\"/config/scripts/beets.log\"" >> "/scripts/lad-config"
echo "TagWithBeets=\"$TagWithBeets\"" >> "/scripts/lad-config"

# Modify script with config location
sed -i "s/source .\/config/source \/scripts\/lad-config/g" "/config/scripts/lidarr-automated-downloader.bash"

# Modify script with chown
sed -i 's/# docker-chown-01/chown abc:abc "$1"\/*/g' "/config/scripts/lidarr-automated-downloader.bash"
sed -i 's/# docker-chown-02/chown -R abc:abc "$1"/g' "/config/scripts/lidarr-automated-downloader.bash"

# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;
find /storage/downloads/lidarr -type f -exec chmod 0666 {} \;
find /storage/downloads/lidarr -type d -exec chmod 0777 {} \;
chown -R abc:abc "/config/scripts"
chown -R abc:abc "/scripts"

echo "Complete..."

exit 0
