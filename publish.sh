#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: publish.sh <destination directory>"
    exit
fi
output=$1

echo "Getting the latest submodules (and deleting all local changes to submodules)"
git submodule foreach git reset --hard
git submodule update --recursive --remote
echo "Patching submodules (adding navbar)"
sed -i -e "s/<\!-- For www.waveformer.net //" -e "s/-->//" midimonitor/index.html
sed -i -e "s/<\!-- For www.waveformer.net //" -e "s/-->//" circuitbender/index.html
echo "Publishing to directory \"$output\""
rsync -avr --exclude='.git' --exclude='.vscode' --exclude='*.sh' --exclude=".gitmodules" . $output

