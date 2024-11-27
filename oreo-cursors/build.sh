#!/bin/bash

cd /usr/src
apt update && apt install -y git make ruby inkscape x11-apps
# Souravgoswami's repo allows for outlined cursors to be generated
git clone https://github.com/Souravgoswami/oreo-cursors.git
# Merge in changes from varlesh's master - auto resolve any conflicts 😬
git remote add upstream https://github.com/varlesh/oreo-cursors.git
git fetch upstream
git merge -X upstream master
cd oreo-cursors
# We dont want to build all the cursors, only the ones specified in cursors.conf
rm -r src/oreo_*
rm -r dist
rm cursors.conf
cat > cursors.conf << EOF
black_outlined = color: #424242, label: #FFF, shadow: #222, shadow-opacity: 0.4, stroke: #fff, stroke-opacity: 1, stroke-width: 1
EOF
ruby generator/convert.rb
make build

if [ ! -d build ]; then
    echo "Build failed"
    exit 1
fi

cp -r dist /app
