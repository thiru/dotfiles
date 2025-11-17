#!/bin/sh

# Launches Kitty in a floating window with a custom command

if [ $# -lt 3 ]; then
  echo "Usage: kitty-dialog.sh <TITLE> <FONT SIZE> <CMD> [<ARGS>]"
  exit 1
fi

TITLE=$1
FONT_SIZE=$2
CMD=$3

shift 3

kitty --title "$TITLE" --app-id launcher --override font_size=$FONT_SIZE $CMD $@
