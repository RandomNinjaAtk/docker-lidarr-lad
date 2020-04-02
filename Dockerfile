FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV VERSION="1.7.0"
ENV UPDATE_LAD TRUE
ENV ENABLE_LAD TRUE
ENV LAD_PATH /usr/local/lad
ENV XDG_CONFIG_HOME="/xdg"
ENV downloaddir="/storage/downloads/lidarr/deezloaderremix"
ENV LidarrImportLocation="/storage/downloads/lidarr/lidarr-import"
ENV LidarrUrl="http://127.0.0.1:8686"
ENV deezloaderurl="http://127.0.0.1:1730"

RUN \
	echo "************ install dependencies ************" && \
	curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	apt-get update -qq && \
	apt-get install -qq -y \
		wget \
		nano \
		unzip \
		nodejs \
		git \
		jq \
		mp3val \
		flac \
		opus-tools \
		beets \
		python3 \
		python3-pip \
		libchromaprint-tools \
		ffmpeg \
		cron && \
	apt-get purge --auto-remove -y && \
	apt-get clean && \
	echo "************ install beets plugin dependencies ************" && \
	pip3 install --no-cache-dir -U \
		requests \
		Pillow \
		pylast \
		pyacoustid && \
	echo "************ setup lad ************" && \
	echo "************ make directory ************" && \
	mkdir -p ${LAD_PATH} && \
	echo "************ download repo ************" && \
	git clone https://github.com/RandomNinjaAtk/lidarr-automated-downloader.git ${LAD_PATH} && \
	mkdir -p "/root/scripts" && \
	echo "************ setup cron ************" && \
	service cron start && \
	echo "*/15 * * * *   root   bash /scripts/lad-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab" && \
	echo "0 0 1 * *   root   rm \"/config/scripts/download.log\""  >> "/etc/crontab" && \
	echo "0 0 1 * *   root   rm \"/config/scripts/notfound.log\""  >> "/etc/crontab" && \
	echo "************ download deezloader ************" && \
	wget https://notabug.org/RemixDevs/DeezloaderRemix/archive/development.zip && \
	unzip development.zip && \
	rm development.zip && \
	echo "************ customize deezloader ************" && \
	sed -i "s/\"trackNameTemplate\": \"%artist% - %title%\"/\"trackNameTemplate\": \"%disc%%number% - %title% %explicit%\"/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"albumTrackNameTemplate\": \"%number% - %title%\"/\"albumTrackNameTemplate\": \"%disc%%number% - %title% %explicit%\"/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"createAlbumFolder\": true/\"createAlbumFolder\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"embeddedArtworkSize\": 800/\"embeddedArtworkSize\": 1400/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"localArtworkSize\": 1000/\"localArtworkSize\": 1400/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"queueConcurrency\": 3/\"queueConcurrency\": 6/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"maxBitrate\": \"3\"/\"maxBitrate\": \"9\"/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"coverImageTemplate\": \"cover\"/\"coverImageTemplate\": \"folder\"/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"createCDFolder\": true/\"createCDFolder\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"removeAlbumVersion\": false/\"removeAlbumVersion\": true/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"syncedlyrics\": false/\"syncedlyrics\": true/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"logErrors\": false/\"logErrors\": true/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"logSearched\": false/\"logSearched\": true/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"trackTotal\": false/\"trackTotal\": true/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"discTotal\": false/\"discTotal\": true/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"publisher\": true/\"publisher\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"date\": true/\"date\": false/g" "/deezloaderremix/app/default.json" && \
	sed -i "s/\"isrc\": true/\"isrc\": false/g" "/deezloaderremix/app/default.json"

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
