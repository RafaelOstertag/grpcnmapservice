#!/bin/sh

set -eu

. ./common.sh

build_java() {
    mkdir -p src/main/proto
    cp -f schema/*.proto src/main/proto
    mvn package
}

install_protoc

PATH="$PWD/protoc/bin:$PWD/go/bin:$PATH"
export PATH
build_java
