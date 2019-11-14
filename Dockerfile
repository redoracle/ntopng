# based on ubuntu 16.04 to run below's commands
FROM ubuntu:18.0



ENV LANG C.UTF-8

RUN  \
  apt-get update \
  && apt-get install -y -q wget \
  && cd /tmp \
  && wget --quiet http://apt.ntop.org/16.04/all/apt-ntop.deb \
  && apt-get install -y -q /tmp/apt-ntop.deb \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y -q pfring nprobe ntopng libndpi-bin libndpi-wireshark ntopng-data \
  && apt-get clean \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/* \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /var/lib/ntopng \
  && useradd ntopng \
  && chown ntopng:ntopng /var/lib/ntopng

EXPOSE 3000 2055
