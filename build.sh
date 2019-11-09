#!/bin/sh

set -eu

PROTOC_VERSION=3.10.1

install_protoc() {
    if [ -d protoc ]
    then
	return 0
    fi

    mkdir protoc

    curl -Lo /tmp/protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip"
    unzip /tmp/protoc.zip -d protoc
}

install_protoc_gen_go() {
    go get -u github.com/golang/protobuf/protoc-gen-go
}


build_go() {
    protoc --go_out=plugins=grpc:. src/github.com/rafaelostertag/nmapservice/nmap.proto
}

build_java() {
    mkdir -p src/main/proto
    cp -f src/github.com/rafaelostertag/nmapservice/*.proto src/main/proto
    mvn compile
}

install_protoc

GOPATH="$PWD/go"
export GOPATH

install_protoc_gen_go

unset GOPATH

PATH="$PWD/protoc/bin:$PWD/go/bin:$PATH"
export PATH
build_go
build_java
