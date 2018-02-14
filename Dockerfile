FROM openjdk:8-jre-alpine
MAINTAINER Evgeniy Slizevich <evgeniy@slizevich.net>

ENV LANG=C.UTF-8

RUN apk add --no-cache \
        bash \
        ca-certificates \
        wget \
        tar \
    && update-ca-certificates \
    && addgroup -S elasticsearch \
    && adduser -g '&' -s /bin/bash -G elasticsearch -S elasticsearch \
    && mkdir /elasticsearch \
    && wget -qO - `wget -qO - https://www.elastic.co/downloads/elasticsearch | grep -Eo 'https://.*?/elasticsearch-.*?.tar.gz' | head -1` | tar xzf - --strip-components=1 -C /elasticsearch \
    && sed -i 's|^#*network.host:: .*$|network.host:: 0.0.0.0|g' /elasticsearch/config/elasticsearch.yml \
    && mv /elasticsearch/config /elasticsearch/config.orig \
    && mkdir /elasticsearch/config

COPY entry /

EXPOSE 9200
EXPOSE 9300

VOLUME /elasticsearch/config
VOLUME /elasticsearch/data
VOLUME /elasticsearch/logs

ENTRYPOINT /entry
