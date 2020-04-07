FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV VERSION="1.7.0"
ENV UPDATE_LAD TRUE
ENV ENABLE_LAD TRUE
ENV LAD_PATH /usr/local/lad
ENV XDG_CONFIG_HOME="/xdg"
ENV downloaddir="/storage/downloads/lidarr/dlclient"
ENV PathToDLClient="/scripts"
ENV LidarrImportLocation="/storage/downloads/lidarr/lidarr-import"
ENV LidarrUrl="http://127.0.0.1:8686"

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
	git clone --single-branch --branch d-fi https://github.com/RandomNinjaAtk/lidarr-automated-downloader.git ${LAD_PATH} && \
	echo "************ download dl client ************" && \
	mkdir -p "/root/scripts" && \
	cd "/root/scripts" && \
	wget https://github.com/d-fi/releases/releases/download/1.3.2/d-fi-linux.zip  && \
	unzip d-fi-linux.zip && \
	rm d-fi-linux.zip && \
	chmod 0777 "/root/scripts/d-fi" && \
	echo "************ setup cron ************" && \
	service cron start && \
	echo "*/15 * * * *   root   bash /scripts/lad-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab" && \
	echo "0 0 1 * *   root   rm \"/config/scripts/download.log\""  >> "/etc/crontab" && \
	echo "0 0 1 * *   root   rm \"/config/scripts/notfound.log\""  >> "/etc/crontab" && \
	
WORKDIR /

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686
VOLUME /config /storage
