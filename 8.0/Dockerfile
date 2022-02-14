FROM bfren/alpine:alpine3.15-1.4.11

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # disable debug messages by default
    BF_DEBUG=0 \
    # PHP config directory
    PHP_DIR=/etc/php8 \
    # php.ini template to use
    PHP_INI="production" \
    # php.ini override: display_errors
    PHP_INI_DISPLAY_ERRORS= \
    # php.ini override: display_startup_errors
    PHP_INI_DISPLAY_STARTUP_ERRORS= \
    # php.ini override: error_log
    PHP_INI_ERROR_LOG="/var/log/php8/error.log" \
    # php.ini override: err-r_reporting
    PHP_INI_ERROR_REPORTING= \
    # php.ini override: memory_limit
    PHP_INI_MEMORY_LIMIT="256M"

COPY ./overlay /
COPY ./8.0/overlay /
COPY ./8.0/PHP_BUILD /tmp/

RUN bf-install

VOLUME [ "/ws" ]

ENTRYPOINT [ "/init" ]
