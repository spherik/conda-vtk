#!/bin/bash

git clone https://github.com/ValveSoftware/openvr.git
export OPENVR_INCLUDE_DIR=./openvr/include
export OPENVR_LIBRARY_TEMP=./openvr/lib/osx32/libopenvr_api.dylib
mkdir build
cd build

export LDFLAGS="-L${PREFIX}/lib $LDFLAGS"

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  DYNAMIC_EXT="so"
fi
if [ "$(uname -s)" == "Darwin" ]; then
  DYNAMIC_EXT="dylib"
fi

if [ $PY3K -eq 1 ]; then
  export PY_STR="${PY_VER}m"
else
  export PY_STR="${PY_VER}"
fi



cmake -LAH .. \
-DCMAKE_INSTALL_PREFIX=$PREFIX \
-DCMAKE_BUILD_TYPE=Release \
-DINSTALL_BIN_DIR=$PREFIX/bin \
-DINSTALL_INC_DIR=$PREFIX/include \
-DINSTALL_LIB_DIR=$PREFIX/lib \
-DINSTALL_PKGCONFIG_DIR=$PREFIX/lib/pkgconfig \
-DBUILD_SHARED_LIBS=1 \
-DBUILD_EXAMPLES=0 \
-DBUILD_TESTING=0 \
-DBUILD_DOCUMENTATION=0 \
-DPYTHON_LIBRARY="$PREFIX/lib/libpython$PY_STR.$DYNAMIC_EXT" \
-DPYTHON_EXECUTABLE=$PYTHON \
-DVTK_WRAP_PYTHON=1 \
-DVTK_INSTALL_PYTHON_MODULE_DIR=$SP_DIR \
-DModule_VTKRenderingOpenVR=1 \
-DOPENVR_INCLUDE_DIR=$OPENVR_INCLUDE_DIR\
-DOPENVR_LIBRARY_TEMP=$OPENVR_LIBRARY_TEMP 

make -j$CPU_COUNT && make install
