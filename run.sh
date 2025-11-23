#!/bin/sh

IMAGE=`cat VERSION`
PHP=${1:-8.4}

docker buildx build \
    --load \
    --build-arg BF_IMAGE=php \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${PHP}/Dockerfile \
    -t php${PHP}-dev \
    . \
    && \
    docker run -it -e BF_DEBUG=1 -e BF_PHP_ENV=development -v $PWD/php-ini-sample.json:/php-ini.json:ro php${PHP}-dev sh
