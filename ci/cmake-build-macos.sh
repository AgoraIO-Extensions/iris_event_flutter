#!/usr/bin/env bash

set -e
set -x

SCRIPTS_PATH=$(dirname "$0")
ROOT_PATH=$(pwd)
BUILD_TYPE="Release"

OUTPUT_ARTIFACTORY_NAME="Agora_Iris_Event_Flutter_for_macOS"
OUTPUT_ARTIFACTORY_PATH=$ROOT_PATH/build/$OUTPUT_ARTIFACTORY_NAME

mkdir -p $OUTPUT_ARTIFACTORY_PATH

bash $ROOT_PATH/cxx/build-macos.sh $ROOT_PATH/cxx $OUTPUT_ARTIFACTORY_PATH $BUILD_TYPE

# Check CFBundleShortVersionString
CFBUNDLESHORTVERSIONSTRING=$(defaults read ${OUTPUT_ARTIFACTORY_PATH}/iris_event_handler.framework/Resources/Info.plist CFBundleShortVersionString)
if [[ -z "${CFBUNDLESHORTVERSIONSTRING}" ]]; then
    echo "CFBundleShortVersionString not found, make sure the MACOSX_FRAMEWORK_SHORT_VERSION_STRING has been set in the CMakeLists.txt"
    exit 1
fi

# Check CFBundleVersion
CFBUNDLEVERSION=$(defaults read ${OUTPUT_ARTIFACTORY_PATH}/iris_event_handler.framework/Resources/Info.plist CFBundleVersion)
if [[ -z "${CFBUNDLEVERSION}" ]]; then
    echo "CFBundleVersion not found, make sure the MACOSX_FRAMEWORK_BUNDLE_VERSION has been set in the CMakeLists.txt"
    exit 1
fi

ZIP_FILE_NAME="${OUTPUT_ARTIFACTORY_NAME}.zip"

pushd $ROOT_PATH/build
zip -r -y "$ZIP_FILE_NAME" $OUTPUT_ARTIFACTORY_NAME
popd