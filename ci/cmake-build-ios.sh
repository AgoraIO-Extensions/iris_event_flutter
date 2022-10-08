#!/usr/bin/env bash

set -e
set -x

SCRIPTS_PATH=$(dirname "$0")
ROOT_PATH=$(pwd)

OUTPUT_ARTIFACTORY_NAME="Agora_Iris_Event_Flutter_for_iOS"
OUTPUT_ARTIFACTORY_PATH=$ROOT_PATH/build/$OUTPUT_ARTIFACTORY_NAME

mkdir -p $OUTPUT_ARTIFACTORY_PATH

bash $ROOT_PATH/cxx/build-ios.sh $ROOT_PATH/cxx $OUTPUT_ARTIFACTORY_PATH

# Check CFBundleShortVersionString
CFBUNDLESHORTVERSIONSTRING=$(defaults read ${OUTPUT_ARTIFACTORY_PATH}/iris_event_handler.xcframework/ios-arm64_armv7/iris_event_handler.framework/Info.plist CFBundleShortVersionString)
if [[ -z "${CFBUNDLESHORTVERSIONSTRING}" ]]; then
    echo "CFBundleShortVersionString not found, make sure the MACOSX_FRAMEWORK_SHORT_VERSION_STRING has been set in the CMakeLists.txt"
    exit 1
fi

# Check CFBundleVersion
CFBUNDLEVERSION=$(defaults read ${OUTPUT_ARTIFACTORY_PATH}/iris_event_handler.xcframework/ios-arm64_armv7/iris_event_handler.framework/Info.plist CFBundleVersion)
if [[ -z "${CFBUNDLEVERSION}" ]]; then
    echo "CFBundleVersion not found, make sure the MACOSX_FRAMEWORK_BUNDLE_VERSION has been set in the CMakeLists.txt"
    exit 1
fi

ZIP_FILE_NAME="${OUTPUT_ARTIFACTORY_NAME}.zip"

pushd $ROOT_PATH/build
zip -r -y "$ZIP_FILE_NAME" $OUTPUT_ARTIFACTORY_NAME
popd