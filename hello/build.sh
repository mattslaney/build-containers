#!/bin/bash
# A simple hello world test build script for testing build-containers is working

set -e

mkdir -p /usr/src/hello
cat > /usr/src/hello/hello.cpp << EOF
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF

mkdir -p /app/build/log
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

mkdir -p /app/build/release
cp /usr/src/hello/hello /app/build/release

