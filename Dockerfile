FROM openjdk:8-jre-slim
MAINTAINER Evgeniy Slizevich <evgeniy@slizevich.net>

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    && addgroup --system elasticsearch \
    && adduser --gecos '&' --shell /bin/bash --ingroup elasticsearch --system elasticsearch \
    && mkdir /elasticsearch \
    && wget -qO - `wget -qO - https://www.elastic.co/downloads/elasticsearch | grep -Eo 'https://.*?/elasticsearch-.*?.tar.gz' | head -1` | tar xzf - --strip-components=1 -C /elasticsearch \
    && sed -i 's|^#*network.host: .*$|network.host: 0.0.0.0|g' /elasticsearch/config/elasticsearch.yml \
    && mv /elasticsearch/config /elasticsearch/config.orig \
    && mkdir /elasticsearch/config

COPY entry /

EXPOSE 9200
EXPOSE 9300

VOLUME /elasticsearch/config
VOLUME /elasticsearch/data
VOLUME /elasticsearch/logs

ENTRYPOINT /entry
