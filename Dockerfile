FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV DOCKER="true"
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
	
# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music
