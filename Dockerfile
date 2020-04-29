FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV VERSION="1.7.4"
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
	mkdir -p "/xdg/deemix" && \
	echo "************ download dl client repo ************" && \
	git clone https://notabug.org/RemixDev/deemix.git ${PathToDLClient} && \
	echo "************ install pip dependencies ************" && \
	pip3 install -r /root/scripts/deemix/requirements.txt --user && \
	echo "************ setup cron ************" && \
	service cron start && \
	echo "*/15 * * * *   root   bash /scripts/lad-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab" && \
	echo "0 0 1 * *   root   rm \"/config/scripts/download.log\""  >> "/etc/crontab" && \
	echo "0 0 1 * *   root   rm \"/config/scripts/notfound.log\""  >> "/etc/crontab"
	
WORKDIR /

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686
VOLUME /config /storage
