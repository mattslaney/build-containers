#!/bin/bash
# A build.sh template

if [ "$BUILD_CONTAINER" != "true" ]; then
    echo "This should be run inside a build container"
    exit 1
fi

echo "Inside build container"

set -e

mkdir -p /app/build     # Somewhere to put build artifacts
mkdir -p /app/build/log # Somewhere to put build logs
mkdir -p /app/dist      # Somewhere to put the release files

/usr/games/cowsay "Well, hello there"

