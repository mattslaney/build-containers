#!/bin/bash
# A simple hello world test build script for testing build-containers is working

if [ "$BUILD_CONTAINER" != "true" ]; then
    echo "This should be run inside a build container"
    exit 1
fi

echo "Inside build container"

set -e

mkdir -p /app/build/log
mkdir -p /app/dist

USER="World"
if [ -n "$1" ]; then
    echo "Using custom user: $1"
    USER=$1
fi

mkdir -p /usr/src/hello
cat > /usr/src/hello/hello.cpp << EOF
#include <iostream>

int main() {
    std::cout << "Hello, $USER!" << std::endl;
    return 0;
}
EOF

g++ -v /usr/src/hello/hello.cpp -o /usr/src/hello/hello 2>&1 | tee /app/build/log/build.log
result=${PIPESTATUS[0]}
if [ $result -ne 0 ]; then
    echo "Build failed with result: $result"
    exit 1
fi

if [ ! -f /usr/src/hello/hello ]; then
    echo "No hello binary was created"
    exit 1
fi

cp /usr/src/hello/hello /app/dist

