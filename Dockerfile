FROM ubuntu:18.04
LABEL MAINTAINER Thiago Almeida <thiagoalmeidasa@gmail.com>

# Install Spotify and PulseAudio.
WORKDIR /usr/src

RUN apt-get update && apt-get install -y gnupg2 \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90 2EBF997C15BDA244B6EBF5D84773BD5E130D1D45 \
  && echo deb http://repository.spotify.com stable non-free > /etc/apt/sources.list.d/spotify.list \
  && apt-get update \
  && apt-get install -y \
  spotify-client xdg-utils libxss1 \
  pulseaudio \
  fonts-noto \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo enable-shm=no >> /etc/pulse/client.conf

# Spotify data.
VOLUME ["/data/cache", "/data/config"]
WORKDIR /data
RUN mkdir -p /data/cache \
  && mkdir -p /data/config

# PulseAudio server.
ENV PULSE_SERVER /run/pulse/native

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["spotify"]
