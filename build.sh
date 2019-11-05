#!/bin/sh

set -eu

build_go() {
    protoc -I schema --go_out=plugins=grpc:. nmap.proto
}

build_java() {
    mkdir -p src/main/proto
    cp -f schema/*.proto src/main/proto
    mvn compile
}

build_go
build_java
