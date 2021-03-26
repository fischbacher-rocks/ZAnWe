
FROM        golang:1.16.2-alpine3.13 AS BUILD_IMAGE
RUN         apk add --update --no-cache -t build-deps curl gcc libc-dev libgcc
WORKDIR     /go/src/github.com/adnanh/webhook
ENV         WEBHOOK_VERSION=2.8.0
RUN         curl -#L -o webhook.tar.gz https://api.github.com/repos/adnanh/webhook/tarball/$(WEBHOOK_VERSION) && \
            tar -xzf webhook.tar.gz --strip 1 &&  \
            go get -d && \
            go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM        alpine:3.13
RUN         apk add --update --no-cache curl tini tzdata
COPY        --from=BUILD_IMAGE /usr/local/bin/webhook /usr/local/bin/webhook

COPY        ./docker-entrypoint.sh /
COPY        ./hooks/ /var/lib/zanwe/hooks/

WORKDIR     /zanwe

EXPOSE      9000

ENTRYPOINT  ["/sbin/tini", "--", "/docker-entrypoint.sh"]
