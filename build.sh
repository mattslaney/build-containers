#!/bin/bash

PROJECT=${1%/}
if [ -z $PROJECT ]; then
    echo "Expected name of project to build"
    exit 1
fi

if [[ $PROJECT == "." ]]; then
    echo "Building build-container"
    podman build -t build-container .
    exit 0
fi

build_container="build-container"

project_dir=$(pwd)/$PROJECT
echo "Building $PROJECT: $project_dir"
chmod +x $project_dir/build.sh

if [ -f $project_dir/Containerfile ]; then
    echo "Project contains own Containerfile, using this"
    build_container="$PROJECT-build-container"
    podman build -f "$project_dir/Containerfile" -t $build_container
fi

if [ $(git ls-files --others -- $PROJECT | wc -l) -ne 0 ]; then
    echo -e "\e[33mProject directory is unclean, do you want to clean it?"
    git ls-files --others -- $PROJECT | awk '{print "    * " $0}'
    read -p "Do you want to delete them?" delete_artifacts
    echo -e -n "\e[0m"
    if [[ $delete_artifacts =~ ^(yes|y)$ ]]; then
        git clean -fdx $project_dir
    fi
fi

if [ "$DEBUG" = "true" ]; then
    echo "Starting container for debug"
    podman run --rm -it -v $project_dir:/app $build_container /bin/bash
else
    echo "Running app build"
    podman run --rm -v $project_dir:/app $build_container
fi

