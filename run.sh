#!/bin/bash

set -ex

PLATFORMS=(qt)
# PLATFORMS=(qt gtk2 gtk3)
# PLATFORMS=(win32)

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 755 $XAUTH

for p in ${PLATFORMS[@]} ; do
    echo "===" ${p} "==="
    TAG=opencv-highgui-${p}
    docker build -t ${TAG} - < Dockerfile-${p}
    docker run -it \
        -v `pwd`/../opencv:/opencv \
        -v `pwd`/../opencv_contrib:/opencv_contrib:ro \
        -v `pwd`/../opencv_extra:/opencv_extra:ro \
        -v `pwd`/scripts:/scripts:ro \
        -v `pwd`/workspace:/workspace \
        -u $(id -u):$(id -g) \
        -e CCACHE_DIR=/workspace/.ccache \
        --net=host \
        -v $XSOCK -v $XAUTH \
        -e XAUTHORITY=$XAUTH \
        -e DISPLAY=$DISPLAY \
        -e OPENCV_TEST_DATA_PATH=/opencv_extra \
        ${TAG} bash /scripts/build.sh ${p}
done
