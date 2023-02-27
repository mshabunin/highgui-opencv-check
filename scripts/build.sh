#!/bin/bash

set -ex

p=$1
d=/workspace/build-${p}
opt=

[ "${p}" == "qt" ] && opt=-DWITH_QT=ON
[ "${p}" == "gtk2" ] && opt="-DWITH_GTK=ON -DWITH_OPENGL=ON"
[ "${p}" == "gtk3" ] && opt=-DWITH_GTK=ON
[ "${p}" == "win32" ] && opt="-DCMAKE_TOOLCHAIN_FILE=/scripts/mingw-w64-x86_64.cmake -DWITH_OPENEXR=OFF -DWITH_PROTOBUF=OFF"

mkdir -p ${d}
pushd ${d} && rm -rf *
# cmake -GNinja -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules ${opt} /opencv
cmake -GNinja ${opt} /opencv
ninja opencv_test_highgui
./bin/opencv_test_highgui
popd
