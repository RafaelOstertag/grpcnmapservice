PROTOC_VERSION=3.14.0

install_protoc() {
    if [ -d protoc ]
    then
	    return 0
    fi

    mkdir protoc

    curl -Lo /tmp/protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip"
    unzip /tmp/protoc.zip -d protoc
}
