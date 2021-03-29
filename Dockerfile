##
##
##
FROM python:3.9-slim-buster AS AWH_IMAGE
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata \
        wget;
WORKDIR /tmp
ENV WEBHOOK_VERSION=2.8.0
RUN wget https://github.com/adnanh/webhook/releases/download/$WEBHOOK_VERSION/webhook-linux-amd64.tar.gz && \
    tar -xzf webhook-linux-amd64.tar.gz --strip 1

##
##
##
FROM python:3.9-slim-buster

# runtime dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata \
        tini \
        curl \
        wget \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY --from=AWH_IMAGE /tmp/webhook /usr/local/bin/webhook

COPY ./build/ /build
COPY ./docker-entrypoint.sh /
COPY ./zanwe/ /var/lib/zanwe

RUN pip3 install \
      --disable-pip-version-check --no-cache --upgrade --upgrade-strategy=only-if-needed \
      -r /build/requirements.txt; \
    ansible-galaxy collection install -r /build/requirements.yml;

WORKDIR /zanwe

EXPOSE 9000

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]
