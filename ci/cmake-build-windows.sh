#!/usr/bin/env bash

set -e
set -x

SCRIPTS_PATH=$(dirname "$0")
ROOT_PATH=$(pwd)
BUILD_TYPE="Release"

OUTPUT_ARTIFACTORY_NAME="Agora_Iris_Event_Flutter_for_Windows"
OUTPUT_ARTIFACTORY_PATH=$ROOT_PATH/build/$OUTPUT_ARTIFACTORY_NAME

mkdir -p $OUTPUT_ARTIFACTORY_PATH

bash $ROOT_PATH/cxx/build-windows.sh $ROOT_PATH/cxx $OUTPUT_ARTIFACTORY_PATH

ZIP_FILE_NAME="${OUTPUT_ARTIFACTORY_NAME}.zip"

pushd $ROOT_PATH/build
tar.exe -a -c -f  "$ZIP_FILE_NAME" $OUTPUT_ARTIFACTORY_NAME
popd