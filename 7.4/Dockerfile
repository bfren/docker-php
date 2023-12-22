FROM bfren/alpine:alpine3.15-2.1.1

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-php"

ARG BF_IMAGE
ARG BF_VERSION

COPY ./overlay /
COPY ./7.4/overlay /

ENV \
    # PHP config directory
    BF_PHP_DIR="/etc/php7" \
    # offical php.ini template to download
    BF_PHP_ENV="production" \
    # space-separated extensions to install
    BF_PHP_EXT= \
    # PHP package prefix
    BF_PHP_PREFIX="php7"

RUN bf-install

VOLUME [ "/ws" ]

ENTRYPOINT [ "/init" ]
