FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

# environment settings
LABEL maintainer="RandomNinjaAtk"
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIDARR_BRANCH="nightly"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN \
	# Download Statup Script
	curl -o "lidarr-automated-installer.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/docker/lidarr-automated-downloader-installer.bash"

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music
COPY lidarr-automated-installer.bash /etc/cont-init.d/lidarr-automated-installer.bash
