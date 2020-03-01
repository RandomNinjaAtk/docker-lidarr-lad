FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

RUN \
	mkdir -p root/ && \
	cd root/ && \
	# Download Statup Script
	curl -o "lidarr-automated-installer.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/docker/lidarr-automated-downloader-installer.bash"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686
VOLUME /config
