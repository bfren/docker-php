#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="2.3.0"
echo "Base: ${BASE_VERSION}"

PHP_VERSIONS="7.4 8.0 8.1 8.2 8.3"
for V in ${PHP_VERSIONS} ; do

    echo "PHP ${V}"
    ALPINE_EDITION=`cat ./${V}/ALPINE_MINOR`
    PHP_PREFIX=`cat ./${V}/PHP_PREFIX`
    PHP_DIR="/etc/${PHP_PREFIX}"

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_VERSION=${BASE_VERSION} \
        ALPINE_EDITION=${ALPINE_EDITION} \
        PHP_DIR=${PHP_DIR} \
        PHP_MINOR=${V} \
        PHP_PREFIX=${PHP_PREFIX}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
