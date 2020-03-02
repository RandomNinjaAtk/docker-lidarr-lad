#!/bin/bash

echo "INSTALLING DEEZLOADER-REMIX"

if [ -d "/deezloaderremix" ]; then
	rm -rf /deezloaderremix
fi

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
	sleep 0.1
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

# Start Deezloader
echo "Starting Deezloader Remix"
nohup node /deezloaderremix/app/app.js &>/dev/null &

exit 0
