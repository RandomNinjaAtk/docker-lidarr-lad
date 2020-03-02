FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

ENV docker="true"
ENV downloaddir="/downloads/deezloaderremix"
ENV LidarrImportLocation="/downloads/lidarr-import"
ENV LidarrUrl="http://127.0.0.1:8686"
ENV LidarrApiKey="$(grep "<ApiKey>" /config/config.xml | sed "s/\  <ApiKey>//;s/<\/ApiKey>//")"
ENV deezloaderurl="http://127.0.0.1:1730"
ENV amount="1000000000"


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
	apt-get clean \
	# restart cron
	service cron restart \
	# Setup Cron Jobs
	echo "*/15 * * * *   root   bash /config/scripts/lidarr-automated-downloader-start.bash > /config/scripts/cron-job.log" >> "/etc/crontab" && \
	echo "0 0 * * SAT   root   rm \"/config/scripts/lidarr-automated-downloader/download.log\""  >> "/etc/crontab" && \
	# restart cron
	service cron restart
	
# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music
