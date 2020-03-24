FROM jrottenberg/ffmpeg:snapshot-ubuntu as ffmpeg
FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

# Add files from ffmpeg
COPY --from=ffmpeg /usr/local/ /usr/local/

ENV VERSION="1.7.0"
ENV XDG_CONFIG_HOME="/xdg"
ENV downloaddir="/storage/downloads/ldiarr/deezloaderremix"
ENV LidarrImportLocation="/storage/downloads/ldiarr/lidarr-import"
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
		opus-tools \
		cron && \
	apt-get purge --auto-remove -y && \
	apt-get clean

RUN \
	# ffmpeg
	apt-get update -qq && \
	apt-get install -qq -y \
		libva-drm2 \
		libva2 \
		i965-va-driver \
		libgomp1 && \
	apt-get purge --auto-remove -y && \
	apt-get clean && \
	chgrp users /usr/local/bin/ffmpeg && \
	chgrp users /usr/local/bin/ffprobe && \
	chmod g+x /usr/local/bin/ffmpeg && \
	chmod g+x /usr/local/bin/ffprobe
	
RUN \
	# Download script
	mkdir -p "/root/scripts" && \
	curl -o "/root/scripts/lidarr-automated-downloader.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/lidarr-automated-downloader.bash" && \
	# setup cron
	service cron start && \
	echo "*/15 * * * *   root   bash /scripts/lad-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab" && \
	echo "0 0 * * SAT   root   rm \"/config/scripts/download.log\""  >> "/etc/crontab" && \
	echo "0 0 * * SAT   root   rm \"/config/scripts/notfound.log\""  >> "/etc/crontab"

RUN \
	# Download Deezloader
	wget https://notabug.org/RemixDevs/DeezloaderRemix/archive/development.zip && \
	unzip development.zip && \
	rm development.zip && \
	# Customize Deezloader Config
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
	sed -i "s/\"publisher\": true/\"publisher\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"date\": true/\"date\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"isrc\": true/\"isrc\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"multitagSeparator\": \"; \"/\"multitagSeparator\": \"andFeat\"/g" "/deezloaderremix/app/default.json"

WORKDIR /deezloaderremix

RUN \
	npm install

WORKDIR /deezloaderremix/app

RUN \
	npm install

WORKDIR /

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686
VOLUME /config /storage
