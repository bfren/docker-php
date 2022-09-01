FROM bfren/alpine:alpineedge-1.6.10

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-php"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # disable debug messages by default
    BF_DEBUG=0 \
    # PHP config directory
    PHP_DIR="/etc/php82" \
    # php.ini template to use
    PHP_INI="production" \
    # php.ini override: display_errors
    PHP_INI_DISPLAY_ERRORS= \
    # php.ini override: display_startup_errors
    PHP_INI_DISPLAY_STARTUP_ERRORS= \
    # php.ini override: error_log
    PHP_INI_ERROR_LOG="/var/log/php82/error.log" \
    # php.ini override: err-r_reporting
    PHP_INI_ERROR_REPORTING= \
    # php.ini override: memory_limit
    PHP_INI_MEMORY_LIMIT="256M"

COPY ./overlay /
COPY ./8.2/overlay /

RUN bf-install

VOLUME [ "/ws" ]

ENTRYPOINT [ "/init" ]