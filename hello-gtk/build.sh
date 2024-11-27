#!/bin/bash
# A simple hello world test build script for testing projects use their own
# Containerfile if one exists

if [ "$BUILD_CONTAINER" != "true" ]; then
    echo "This should be run inside a build container"
    exit 1
fi

echo "Inside build container"

set -e

mkdir -p /usr/src/hello
cp ./src/hello.cpp /usr/src/hello
cd /usr/src/hello

mkdir -p /app/build/log
g++ hello.cpp -o hello `pkg-config --cflags --libs gtk+-3.0` 2>&1 | tee /app/build/log/build.log
result=${PIPESTATUS[0]}
if [ $result -ne 0 ]; then
    echo "Build failed with result: $result"
    exit 1
fi

if [ ! -f /usr/src/hello/hello ]; then
    echo "No hello binary was created"
    exit 1
fi

mkdir -p /app/dist
cp /usr/src/hello/hello /app/dist

