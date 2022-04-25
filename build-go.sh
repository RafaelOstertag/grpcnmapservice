#!/bin/sh

set -eu

. ./common.sh

install_protoc_gen_go() {
    go install github.com/golang/protobuf/protoc-gen-go@v1.5.2
}

build_go() {
    protoc -I schema --go_out=plugins=grpc:. --go_opt=module=github.com/RafaelOstertag/grpcnmapservice nmap.proto health.proto
}

install_protoc

GOPATH="$PWD/go"
export GOPATH

install_protoc_gen_go

unset GOPATH

PATH="$PWD/protoc/bin:$PWD/go/bin:$PATH"
export PATH
build_go

