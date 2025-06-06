FROM ghcr.io/bfren/alpine:alpine3.16-2.9.0

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-php"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

COPY ./overlay /
COPY ./8.0/overlay /

ENV \
    # PHP config directory
    BF_PHP_DIR="/etc/php8" \
    # offical php.ini template to download
    BF_PHP_ENV="production" \
    # space-separated extensions to install
    BF_PHP_EXT= \
    # PHP package prefix
    BF_PHP_PREFIX="php8"

RUN bf-install

VOLUME [ "/ws" ]

ENTRYPOINT [ "/init" ]
