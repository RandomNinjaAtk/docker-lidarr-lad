FROM linuxserver/lidarr:preview

# environment settings
LABEL maintainer="RandomNinjaAtk"
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIDARR_BRANCH="nightly"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN \
	mkdir -p /config/custom-cont-init.d && \
	curl -o "/config/custom-cont-init.d/lidarr-automated-installer.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/docker/lidarr-automated-downloader-installer.bash"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686 1730
VOLUME /config
