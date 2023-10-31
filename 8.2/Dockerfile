FROM bfren/alpine:alpine3.18-2.0.0-dev

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-php"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # PHP config directory
    BF_PHP_DIR="/etc/php82" \
    # offical php.ini template to download
    BF_PHP_ENV="production"

COPY ./overlay /
COPY ./8.2/overlay /

RUN bf-install

VOLUME [ "/ws" ]

ENTRYPOINT [ "/init" ]
