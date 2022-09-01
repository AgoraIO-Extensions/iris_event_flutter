#!/usr/bin/env bash

set -e
set -x

SCRIPTS_PATH=$(dirname "$0")
ROOT_PATH=$(pwd)

OUTPUT_ARTIFACTORY_NAME="Agora_Iris_Event_Flutter_for_Android"
OUTPUT_ARTIFACTORY_PATH=$ROOT_PATH/build/$OUTPUT_ARTIFACTORY_NAME

mkdir -p $OUTPUT_ARTIFACTORY_PATH

bash $ROOT_PATH/cxx/build-android.sh $ROOT_PATH/cxx $OUTPUT_ARTIFACTORY_PATH

ZIP_FILE_NAME="${OUTPUT_ARTIFACTORY_NAME}.zip"

pushd $ROOT_PATH/build
zip -r -y "$ZIP_FILE_NAME" $OUTPUT_ARTIFACTORY_NAME
popd