FROM linuxserver/lidarr:preview
LABEL maintainer="RandomNinjaAtk"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8686 1730
VOLUME /config /downloads /music

