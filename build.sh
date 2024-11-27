#!/bin/bash
# This is the main build-container script used to build project subdirectories

clean() {
    local $PROJECT=$1
    git clean -fdx $PROJECT
}

# Process first arg
PROJECT=${1%/}
if [ -z $PROJECT ]; then
    echo "Expected name of project to build"
    exit 1
fi

# We expect it to be a project directory
if [ ! -d $PROJECT ]; then
    echo "Expected first arg to be subdirectory (project)"
    exit 1
fi

shift

# Process remaining args
while test $# -gt 0
do
    case "$1" in
        --)         # echo "Got to --, next args are for project script"
                    shift
                    break
                    ;;
        --clean)    # echo "Cleaning $PROJECT"
                    clean
                    ;;
        *)          echo -e "\e[33mUnexpected arg: $1\e[0m"
                    ;;
    esac
    shift
done

# 
if [[ $PROJECT == "." ]]; then
    echo "Building build-container"
    podman build -t build-container .
    exit 0
fi

build_container="build-container"

project_dir=$(pwd)/$PROJECT
echo "Building $PROJECT: $project_dir"
chmod +x $project_dir/build.sh

# If the project has it's own Containerfile, use that
if [ -f $project_dir/Containerfile ]; then
    echo "Project contains own Containerfile, using that"
    build_container="$PROJECT-build-container"
    podman build -f "$project_dir/Containerfile" -t $build_container
fi

# Before running check if there are existing build artifacts - unclean tree
# Unless it's a new (untracked) project dir
if git ls-files --error-unmatch $PROJECT &>/dev/null; then
    if [ $(git ls-files --others -- $PROJECT | wc -l) -ne 0 ]; then
        echo -e "\e[33mProject directory is unclean, do you want to clean it?"
        git ls-files --others -- $PROJECT | awk '{print "    * " $0}'
        read -p "Do you want to delete them?" delete_artifacts
        echo -e -n "\e[0m"
        if [[ $delete_artifacts =~ ^(yes|y)$ ]]; then
            clean $PROJECT
        fi
    fi
fi

echo "Starting build in $build_container"
echo -e "\e[34m"
if [ "$DEBUG" = "true" ]; then
    podman run --rm -it -v $project_dir:/app -e ARGS="$@" $build_container /bin/bash
else
    podman run --rm -v $project_dir:/app $build_container /app/build.sh "$@"
fi
echo -e "\e[0m"

echo "Build finished"

