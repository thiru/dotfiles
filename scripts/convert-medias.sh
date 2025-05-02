#!/bin/bash

# Convert all specified files from one media format to another

if [ $# -lt 2 ]; then
  echo "Usage: convert-medias.sh SOURCE-TYPE TARGET-TYPE"
  echo "Example: convert-medias.sh mp4 mp3"
  exit 1
fi

echo "Converting all $1 files to $2..."
echo

for i in *.$1 ; do
  ffmpeg -i "$i" "$(basename "${i/.$1}").$2"
  sleep 1
done
