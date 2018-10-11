@echo off
setlocal EnableDelayedExpansion
git clone https://github.com/ValveSoftware/openvr.git
set OPENVR_INCLUDE_DIR=./openvr/include
set OPENVR_LIBRARY_TEMP=./openvr/lib/osx32/libopenvr_api.dylib

mkdir build
cd build

if "%PY_VER%" == "3.4" (
    set GENERATOR=Visual Studio 10 2010
) else (
    if "%PY_VER%" == "3.5" (
        set GENERATOR=Visual Studio 14 2015
    ) else (
        set GENERATOR=Visual Studio 9 2008
    )
)

if %ARCH% EQU 64 (
    set GENERATOR=%GENERATOR% Win64
)

cmake -LAH .. -G"%GENERATOR%" ^
-DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
-DCMAKE_BUILD_TYPE=Release ^
-DINSTALL_BIN_DIR=%LIBRARY_BIN% ^
-DINSTALL_INC_DIR=%LIBRARY_INC% ^
-DINSTALL_LIB_DIR=%LIBRARY_LIB% ^
-DBUILD_SHARED_LIBS=1 ^
-DBUILD_EXAMPLES=0 ^
-DBUILD_TESTING=0 ^
-DBUILD_DOCUMENTATION=0 ^
-DBUILD_SHARED_LIBS=1 ^
-DPYTHON_EXECUTABLE=%PYTHON% ^
-DVTK_WRAP_PYTHON=1 ^
-DVTK_INSTALL_PYTHON_MODULE_DIR=%SP_DIR% ^
-DModule_VTKRenderingOpenVR=1  ^
-DOPENVR_INCLUDE_DIR=%OPENVR_INCLUDE_DIR% ^
-DOPENVR_LIBRARY_TEMP=%OPENVR_LIBRARY_TEMP%

cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
