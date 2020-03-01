#!/bin/bash
echo "==========start lidarr-automated-installer automated updates==========="

echo "INSTALLING DEEZLOADER-REMIX"

rm -rf /deezloaderremix && \

if [ -d "/config/xdg" ]; then
	rm -rf /config/xdg
fi

if [ ! -d /downloads/deezloaderremix ]; then
	mkdir /downloads/deezloaderremix
fi

ln -sf /downloads/deezloaderremix "/root/Deezloader Music" && \

cd / && \
if [ -f /development.zip  ]; then
	rm /development.zip 
	sleep 1s
fi

wget https://notabug.org/RemixDevs/DeezloaderRemix/archive/development.zip && \
unzip development.zip && \
rm development.zip && \

sed -i "s/\"trackNameTemplate\": \"%artist% - %title%\"/\"trackNameTemplate\": \"%disc%%number% - %title% %explicit%\"/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"albumTrackNameTemplate\": \"%number% - %title%\"/\"albumTrackNameTemplate\": \"%disc%%number% - %title% %explicit%\"/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"createAlbumFolder\": true/\"createAlbumFolder\": false/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"embeddedArtworkSize\": 800/\"embeddedArtworkSize\": 1000/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"localArtworkSize\": 1000/\"localArtworkSize\": 1400/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"saveArtwork\": false/\"saveArtwork\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"queueConcurrency\": 3/\"queueConcurrency\": 6/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"maxBitrate\": \"3\"/\"maxBitrate\": \"9\"/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"coverImageTemplate\": \"cover\"/\"coverImageTemplate\": \"folder\"/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"createCDFolder\": true/\"createCDFolder\": false/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"createSingleFolder\": false/\"createSingleFolder\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"removeAlbumVersion\": false/\"removeAlbumVersion\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"syncedlyrics\": false/\"syncedlyrics\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"logErrors\": false/\"logErrors\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"logSearched\": false/\"logSearched\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"trackTotal\": false/\"trackTotal\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"discTotal\": false/\"discTotal\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"explicit\": false/\"explicit\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"barcode\": false/\"barcode\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"unsynchronisedLyrics\": false/\"unsynchronisedLyrics\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"copyright\": false/\"copyright\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"musicpublisher\": false/\"musicpublisher\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"composer\": false/\"composer\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"mixer\": false/\"mixer\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"author\": false/\"author\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"writer\": false/\"writer\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"engineer\": false/\"engineer\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"producer\": false/\"producer\": true/g" "/deezloaderremix/app/default.json" && \
sed -i "s/\"multitagSeparator\": \"; \"/\"multitagSeparator\": \"andFeat\"/g" "/deezloaderremix/app/default.json" && \

cd /deezloaderremix && \
npm install && \
cd /deezloaderremix/app && \
npm install && \
cd / && \

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

if [ ! -f "/config/scripts/lidarr-automated-downloader/config" ]; then
    echo "downloading config from: https://github.com/RandomNinjaAtk/lidarr-automated-downloader/blob/master/config"
    curl -o "/config/scripts/lidarr-automated-downloader/config" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/config"
    echo "done"
fi

# Set permissions
find /config/scripts -type f -exec chmod 0666 {} \;
find /config/scripts -type d -exec chmod 0777 {} \;

if [ -d "/config/xdg" ]; then
	chmod 0777 -R /config/xdg
fi



# Start Deezloader
echo "Starting Deezloader Remix"
nohup node /deezloaderremix/app/app.js &>/dev/null &
sleep 20s

if [ -x "$(command -v crontab)" ]; then	
	if grep "lidarr-automated-downloader-start.bash" /etc/crontab | read; then
		echo "job already added..."
	else
		echo "adding cron job to crontab..."
		echo "*/15 * * * *   root   bash /config/scripts/lidarr-automated-downloader-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab"
	fi
	if grep "musicbrainzerror.log" /etc/crontab | read; then
		echo "job already added..."
	else
		echo "adding cron job to crontab..."
		echo "0 18 * * *   root   rm \"/config/scripts/lidarr-automated-downloader/musicbrainzerror.log\" && touch \"/config/scripts/lidarr-automated-downloader/musicbrainzerror.log\""  >> "/etc/crontab"
	fi
	if grep "daily.log" /etc/crontab | read; then
		echo "job already added..."
	else
		echo "adding cron job to crontab..."
		echo "5 18 * * *   root   rm \"/config/scripts/lidarr-automated-downloader/daily.log\" && touch \"/config/scripts/lidarr-automated-downloader/daily.log\""  >> "/etc/crontab"
	fi
	service cron restart
else
	echo "cron NOT INSTALLED"
fi

echo "==========end start lidarr-automated-installer automated updates==========="
exit 0
