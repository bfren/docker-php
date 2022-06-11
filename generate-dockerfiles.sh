#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="1.6.0"
echo "Base: ${BASE_REVISION}"

PHP_VERSIONS="7.3 7.4 8.0 8.1"
for V in ${PHP_VERSIONS} ; do

    echo "PHP ${V}"
    PHP_MAJOR="$(echo ${V} | cut -c 1)"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        ALPINE_MINOR=${ALPINE_MINOR} \
        PHP_MAJOR=${PHP_MAJOR} \
        PHP_MINOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
