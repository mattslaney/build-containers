#!/bin/bash

cd /usr/src
apt update && apt install -y git make ruby inkscape x11-apps
git clone https://github.com/Souravgoswami/oreo-cursors.git
git remote add upstream https://github.com/varlesh/oreo-cursors.git
git fetch upstream
git merge -X upstream master
cd oreo-cursors
cat > cursors.conf << EOF
black_outlined = color: #424242, label: #FFF, shadow: #222, shadow-opacity: 0.4, stroke: #fff, stroke-opacity: 1, stroke-width: 1
EOF
make build

if [ ! -d build ]; then
    echo "Build failed"
    exit 1
fi

cp -r build /app
