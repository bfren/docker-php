FROM bfren/alpine:alpine3.18-2.0.0-dev

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-php"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # disable debug messages by default
    BF_DEBUG=0 \
    # PHP config directory
    BF_PHP_DIR="/etc/php81" \
    # php.ini template to use
    BF_PHP_INI="production" \
    # php.ini override: display_errors
    BF_PHP_INI_DISPLAY_ERRORS= \
    # php.ini override: display_startup_errors
    BF_PHP_INI_DISPLAY_STARTUP_ERRORS= \
    # php.ini override: error_log
    BF_PHP_INI_ERROR_LOG="/var/log/php81/error.log" \
    # php.ini override: error_reporting
    BF_PHP_INI_ERROR_REPORTING= \
    # php.ini override: post_max_size
    BF_PHP_INI_MAX_POST= \
    # php.ini override: memory_limit
    BF_PHP_INI_MEMORY_LIMIT="256M" \
    # php.ini override: session.gc_maxlifetime
    BF_PHP_INI_SESSION_MAX_LIFETIME=

COPY ./overlay /
COPY ./8.1/overlay /

RUN bf-install

VOLUME [ "/ws" ]

ENTRYPOINT [ "/init" ]
