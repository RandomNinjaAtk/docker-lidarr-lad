FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

# environment settings
LABEL maintainer="RandomNinjaAtk"
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIDARR_BRANCH="nightly"
ENV XDG_CONFIG_HOME="/config/xdg"
ENV LADTEMP /config/custom-cont-init.d

RUN \
	# make directory
  	mkdir -p ${LADTEMP} && \
	# Download Statup Script
	curl -o "${LADTEMP}/lidarr-automated-installer.bash" "https://raw.githubusercontent.com/RandomNinjaAtk/lidarr-automated-downloader/master/docker/lidarr-automated-downloader-installer.bash"

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music
COPY root/ /
