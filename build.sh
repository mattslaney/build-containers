#!/bin/bash

PROJECT=$1
if [ -z $PROJECT ]; then
    echo "Expected name of project to build"
    exit 1
fi

if [[ $PROJECT == "." ]]; then
    echo "Building ubuntu-build-container"
    podman build -t ubuntu-build-container .
    exit 0
fi

project_dir=$(pwd)/$PROJECT
echo "Building $PROJECT: $project_dir"
chmod +x $project_dir/build.sh

if [ -d $project_dir/build ]; then
    echo -e "\e[33mProject directory contains artifacts from a previous build\e[0m"
    read -p "Do you want to delete them?" delete_artifacts
    if [[ $delete_artifacts == "yes" ]]; then
        rm -r $project_dir/build
    fi
fi

if [ $DEBUG = true ]; then
    echo "Starting container for debug"
    podman run --rm -it -v $project_dir:/app ubuntu-build-container /bin/bash
else
    echo "Running app build"
    podman run --rm -v $project_dir:/app ubuntu-build-container
fi

