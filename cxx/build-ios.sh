#!/usr/bin/env bash

set -e
set -x

IRIS_EVENT_DIR=$1
OUT_DIR=$2

ARCHS="OS64COMBINED SIMULATOR64"
BUILD_TYPE="Release"

# ROOT_PATH=$(pwd)
# IRIS_INTEGRATION_TEST_PATH=$ROOT_PATH/integration_test_app/iris_integration_test

archs="armv7 arm64"

for ARCH in ${ARCHS};
do
    if [ ! -d "$IRIS_EVENT_DIR/build/ios/$ARCH" ]; then
        mkdir -p $IRIS_EVENT_DIR/build/ios/$ARCH
    fi

    if [ "$ARCH" = "OS64COMBINED" ]; then
      archs="armv7 arm64"
    elif [ "$ARCH" = "SIMULATOR64" ]; then
      archs="arm64 x86_64"
    fi
    
    pushd $IRIS_EVENT_DIR/build/ios/$ARCH
      cmake \
        -G "Xcode" \
        -DCMAKE_TOOLCHAIN_FILE="${IRIS_EVENT_DIR}/ios.toolchain.cmake" \
        -DPLATFORM="$ARCH" \
        -DARCHS="$archs" \
        -DDEPLOYMENT_TARGET="9.0" \
        -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
        "$IRIS_EVENT_DIR"
      cmake --build . --config "$BUILD_TYPE"
    popd
    unset archs
done;



# cp -RP "${IRIS_EVENT_DIR}/build/ios/OS64COMBINED/Debug-iphoneos/iris_event_handler.framework" "${OUT_DIR}/iris_event_handler.framework"

# echo "Generating framework"
# lipo -create "$IRIS_EVENT_DIR/build/ios/OS64COMBINED/Debug-iphoneos/iris_event_handler.framework/iris_event_handler" "$IRIS_EVENT_DIR/build/ios/SIMULATOR64/Debug-iphonesimulator/iris_event_handler.framework/iris_event_handler" -output "$OUT_DIR/iris_event_handler.framework/iris_event_handler"


rm -rf "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE"
mkdir -p "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE"

echo "start create .framework ----------"
xcodebuild -create-xcframework \
  -framework "${IRIS_EVENT_DIR}/build/ios/OS64COMBINED/$BUILD_TYPE/iris_event_handler.framework" \
  -debug-symbols "${IRIS_EVENT_DIR}/build/ios/OS64COMBINED/$BUILD_TYPE/iris_event_handler.framework.dSYM" \
  -framework "${IRIS_EVENT_DIR}/build/ios/SIMULATOR64/$BUILD_TYPE/iris_event_handler.framework" \
  -debug-symbols "${IRIS_EVENT_DIR}/build/ios/SIMULATOR64/$BUILD_TYPE/iris_event_handler.framework.dSYM" \
  -output "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE/iris_event_handler.xcframework"

mkdir -p ${OUT_DIR}/dSYMs
mkdir -p ${OUT_DIR}/dSYMs/ios-arm64_armv7
mkdir -p ${OUT_DIR}/dSYMs/ios-arm64_x86_64-simulator

cp -RP "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE/iris_event_handler.xcframework/ios-arm64_armv7/dSYMs" "${OUT_DIR}/dSYMs/ios-arm64_armv7"
rm -rf "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE/iris_event_handler.xcframework/ios-arm64_armv7/dSYMs"
cp -RP "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE/iris_event_handler.xcframework/ios-arm64_x86_64-simulator/dSYMs" "${OUT_DIR}/dSYMs/ios-arm64_x86_64-simulator"
rm -rf "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE/iris_event_handler.xcframework/ios-arm64_x86_64-simulator/dSYMs"

cp -RP "${IRIS_EVENT_DIR}/build/ios/ALL_ARCHITECTURE/$BUILD_TYPE/iris_event_handler.xcframework" "${OUT_DIR}"


