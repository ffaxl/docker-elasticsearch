FROM openjdk:8-jre-slim
LABEL maintainer="Evgeniy Slizevich <evgeniy@slizevich.net>"

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    && addgroup --system elasticsearch \
    && adduser --gecos '&' --shell /bin/bash --ingroup elasticsearch --system elasticsearch \
    && mkdir /elasticsearch \
    && wget -qO - https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.0.0-linux-x86_64.tar.gz | tar xzf - --strip-components=1 -C /elasticsearch \
    && sed -i 's|^#*network.host: .*$|network.host: 0.0.0.0|g' /elasticsearch/config/elasticsearch.yml \
    && mv /elasticsearch/config /elasticsearch/config.orig \
    && mkdir /elasticsearch/config \
    && chown -R elasticsearch:elasticsearch /elasticsearch

COPY entry /

EXPOSE 9200
EXPOSE 9300

VOLUME /elasticsearch/config
VOLUME /elasticsearch/data
VOLUME /elasticsearch/logs

ENTRYPOINT /entry
