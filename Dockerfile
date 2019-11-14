# based on ubuntu 16.04 to run below's commands
FROM ubuntu:latest
MAINTAINER RedOracle

# Pass --build-arg TZ=<YOUR_TZ> when running docker build to override this.
ARG TZ=America/Los_Angeles
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF



LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.name='NtopNG by Redoracle' \
      org.label-schema.description='NtopNG docker image' \
      org.label-schema.usage='https://www.redoracle.com/docker/' \
      org.label-schema.url='https://www.redoracle.com/' \
      org.label-schema.vendor='Red0racle S3curity' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd='docker run -dit redoracle/ntopng' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti redoracle/ntopng' \
      org.label-schema.docker.debug='docker logs $CONTAINER' \
      io.github.offensive-security.docker.dockerfile="Dockerfile" \
      io.github.offensive-security.license="GPLv3" \
      MAINTAINER="RedOracle <info@redoracle.com>"

WORKDIR /root

VOLUME /datak

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
    && sed -i -e 's/^root::/root:*:/' /etc/shadow \
    && apt-get -yqq update \                                                       
    && apt-get -yqq dist-upgrade \
    && apt-get install -y -q wget lsb-release gnupg tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && wget -O apt-ntop-stable.deb http://apt-stable.ntop.org/18.04/all/apt-ntop-stable.deb \
    && dpkg -i apt-ntop-stable.deb && rm -f apt-ntop-stable.deb \
    && apt-get update && apt-get -y install ntopng \
    && apt-get install --no-install-recommends --no-install-suggests -y -q pfring nprobe ntopng libndpi-bin libndpi-wireshark ntopng-data \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/ntopng \
    && chown ntopng:ntopng /var/lib/ntopng \
    && echo '#!/usr/bin/env bash\n/etc/init.d/redis-server start && ntopng "$@"' > /tmp/run.sh \
    && chmod +x /tmp/run.sh


EXPOSE 3000 2055

ENTRYPOINT ["/tmp/run.sh"]
