FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV VERSION="2.0.0"
ENV UPDATE_LAD TRUE
ENV UPDATE_DLCLIENT TRUE
ENV ENABLE_LAD TRUE
ENV LAD_PATH /usr/local/lad
ENV XDG_CONFIG_HOME="/xdg"
ENV PYTHON="python3"
ENV downloaddir="/storage/downloads/lidarr/dlclient"
ENV PathToDLClient="/root/scripts/deemix"
ENV LidarrImportLocation="/storage/downloads/lidarr/lidarr-import"
ENV LidarrUrl="http://127.0.0.1:8686"
ENV DLMODE="wanted"
ENV MBRAINZMIRROR="http://musicbrainz.org"

RUN \
	echo "************ install dependencies ************" && \
	apt-get update -qq && \
	apt-get install -qq -y \
		wget \
		nano \
		unzip \
		git \
		jq \
		mp3val \
		flac \
		opus-tools \
		eyed3 \
		beets \
		python3 \
		python3-pip \
		libchromaprint-tools \
		ffmpeg \
		imagemagick \
		python3-pythonmagick \
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
	echo "************ download dl client ************" && \
	echo "************ make directory ************" && \
	mkdir -p ${PathToDLClient} && \
	mkdir -p "${XDG_CONFIG_HOME}/deemix" && \
	echo "************ download dl client repo ************" && \
	git clone https://notabug.org/RemixDev/deemix.git ${PathToDLClient} && \
	echo "************ install pip dependencies ************" && \
	pip3 install -r /root/scripts/deemix/requirements.txt --user && \
	echo "************ customize deezloader ************" && \
	sed -i 's/"downloadLocation": "",/"downloadLocation": "\/storage\/downloads\/lidarr\/dlclient",/g' "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"tracknameTemplate\": \"%artist% - %title%\"/\"tracknameTemplate\": \"%discnumber%%tracknumber% - %title% %explicit%\"/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"albumTracknameTemplate\": \"%tracknumber% - %title%\"/\"albumTracknameTemplate\": \"%discnumber%%tracknumber% - %title% %explicit%\"/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"createAlbumFolder\": true/\"createAlbumFolder\": false/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"embeddedArtworkSize\": 800/\"embeddedArtworkSize\": 1800/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"removeAlbumVersion\": false/\"removeAlbumVersion\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"syncedLyrics\": false/\"syncedLyrics\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"coverImageTemplate\": \"cover\"/\"coverImageTemplate\": \"folder\"/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"fallbackSearch\": false/\"fallbackSearch\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"trackTotal\": false/\"trackTotal\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"discTotal\": false/\"discTotal\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"explicit\": false/\"explicit\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"length\": true/\"length\": false/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"lyrics\": false/\"lyrics\": true/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"label\": true/\"label\": false/g" "/root/scripts/deemix/deemix/app/default.json" && \
	sed -i "s/\"barcode\": true/\"barcode\": false/g" "/root/scripts/deemix/deemix/app/default.json" && \
	cp "/root/scripts/deemix/deemix/app/default.json" "/xdg/deemix/config.json" && \
	chmod 0777 -R "/xdg/deemix" && \
	echo "************ setup cron ************" && \
	service cron start && \
	echo "*/15 * * * *   root   bash /scripts/lad-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab"
	
WORKDIR /

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686
VOLUME /config /storage
