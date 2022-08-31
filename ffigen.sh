#!/usr/bin/env bash

set -e
set -x

CURRENT_PATH=$(pwd)

mkdir -p $CURRENT_PATH/ffigen_include

cp -RP $CURRENT_PATH/cxx/src/iris_event.h $CURRENT_PATH/ffigen_include/iris_event.h
cp -RP $CURRENT_PATH/cxx/third_party/dart-sdk/include/* $CURRENT_PATH/ffigen_include/

 flutter pub run ffigen --config $CURRENT_PATH/ffigen_config.yaml

 rm -rf $CURRENT_PATH/ffigen_include