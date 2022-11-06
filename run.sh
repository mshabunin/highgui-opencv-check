#!/bin/bash

set -ex

PLATFORMS=(win32 qt gtk2 gtk3)
# PLATFORMS=(win32)

for p in ${PLATFORMS[@]} ; do
    echo "===" ${p} "==="
    TAG=opencv-highgui-${p}
    docker build -t ${TAG} - < Dockerfile-${p}
    docker run -it \
        -v `pwd`/../opencv:/opencv \
        -v `pwd`/../opencv_contrib:/opencv_contrib \
        -v `pwd`/scripts:/scripts:ro \
        -v `pwd`/workspace:/workspace \
        -u $(id -u):$(id -g) \
        -e CCACHE_DIR=/workspace/.ccache \
        ${TAG} bash /scripts/build.sh ${p}
done
