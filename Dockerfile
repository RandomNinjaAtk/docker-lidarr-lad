FROM linuxserver/lidarr:preview

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIDARR_BRANCH="nightly"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN \

# Check for folder, create folder if needed (hotio docker image compatibility)
if [ ! -d /config/custom-cont-init.d ]; then
	mkdir -p /config/custom-cont-init.d
fi

if [ -f /config/custom-cont-init.d/lidarr-automated-installer.bash ]; then
	echo "Previous version detected..."
	echo "removing....lidarr-automated-installer.bash"
	rm /config/custom-cont-init.d/lidarr-automated-installer.bash
fi
if [ ! -f /config/custom-cont-init.d/lidarr-automated-installer.bash ]; then
	echo "begining updated script installation..."
	echo "downloading lidarr-automated-installer.bash from: https://github.com/RandomNinjaAtk/lidarr-automated-downloader/blob/master/docker/lidarr-automated-downloader-installer.bash"  && \
	curl -o "/config/custom-cont-init.d/lidarr-automated-installer.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/docker/lidarr-automated-downloader-installer.bash" && \
	echo "download complete" && \
	echo "running lsio-automated-installer.bash..." && \
	bash /config/custom-cont-init.d/lidarr-automated-installer.bash && \
	rm /config/custom-cont-init.d/lidarr-automated-installer.bash
fi

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music
