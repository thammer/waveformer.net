#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: publish.sh <destination directory>"
    exit
fi
output=$1

echo "Publishing to directory \"$output\""
rsync -avr --exclude='.git' --exclude='.vscode' --exclude='*.sh' . $output

mkdir -p $output/midimonitor
cp ../midimonitor/index.html $output/midimonitor 
