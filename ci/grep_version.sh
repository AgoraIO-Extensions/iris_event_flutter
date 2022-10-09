#!/usr/bin/env bash

set -e

ROOT_PATH=$(pwd)

grep "set(IRIS_EVENT_VERSION \".*\")" ${ROOT_PATH}/cxx/CMakeLists.txt | cut -d "\"" -f 2