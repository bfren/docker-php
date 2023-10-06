#!/bin/sh

IMAGE=`cat VERSION`
PHP=${1:-8.1}

docker buildx build \
    --load \
    --build-arg BF_IMAGE=php \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${PHP}/Dockerfile \
    -t php${PHP}-dev \
    . \
    && \
    docker run -it php${PHP}-dev sh
