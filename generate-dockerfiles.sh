#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="1.6.6"
echo "Base: ${BASE_REVISION}"

PHP_VERSIONS="7.3 7.4 8.0 8.1"
for V in ${PHP_VERSIONS} ; do

    echo "PHP ${V}"
    PHP_MAJOR="$(echo ${V} | cut -c 1)"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    if [ "${V}" = "8.1" ] ; then
        PHP_DIR="/etc/php81"
        PHP_INI_ERROR_LOG="/var/log/php81/error.log"
    else
        PHP_DIR="/etc/php${PHP_MAJOR}"
        PHP_INI_ERROR_LOG="/var/log/php${PHP_MAJOR}/error.log"
    fi

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        ALPINE_MINOR=${ALPINE_MINOR} \
        PHP_MAJOR=${PHP_MAJOR} \
        PHP_MINOR=${V} \
        PHP_DIR=${PHP_DIR} \
        PHP_INI_ERROR_LOG=${PHP_INI_ERROR_LOG}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
