FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV VERSION="1.0.0"
ENV downloaddir="/downloads/deezloaderremix"
ENV LidarrImportLocation="/downloads/lidarr-import"
ENV LidarrUrl="http://127.0.0.1:8686"
ENV deezloaderurl="http://127.0.0.1:1730"

RUN \
	# install dependancies
	curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	apt-get update -qq && \
	apt-get install -qq -y \
		mp3val \
		flac \
		wget \
		nano \
		unzip \
		nodejs \
		git \
		jq \
		ffmpeg \
		cron && \
	apt-get purge --auto-remove -y && \
	apt-get clean

RUN \
	# Download Deezloader
	wget https://notabug.org/RemixDevs/DeezloaderRemix/archive/development.zip && \
	unzip development.zip && \
	rm development.zip && \
	# Update deezloader config settings
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
	sed -i "s/\"multitagSeparator\": \"; \"/\"multitagSeparator\": \"andFeat\"/g" "/deezloaderremix/app/default.json"
	# Install deezloader
	cd deezloaderremix && \
	npm install && \
	cd deezloaderremix/app && \
	npm install

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music
