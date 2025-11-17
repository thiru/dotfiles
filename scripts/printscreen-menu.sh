#!/bin/sh

# Take a screenshot or record screen

SCREENSHOTS_DIR=~/Pictures/screen-shots
SCREENRECORDS_DIR=~/Videos/screen-recordings

OPTIONS="screenshot-screen-file
screenshot-screen-clipboard
screenshot-region-file
screenshot-region-clipboard
record-screen-file
record-region-file"

SELECTION=$(echo "$OPTIONS" | fzf)

case "$SELECTION" in
  "screenshot-screen-file")
    sleep 1s
    grim $SCREENSHOTS_DIR/screen-$(date +'%Y-%m-%dT%H-%M-%S').png && notify-send "Screenshot saved to $SCREENSHOTS_DIR"
    ;;
  "screenshot-screen-clipboard")
    sleep 1s
    grim - | wl-copy && notify-send "Screenshot saved to clipboard"
    ;;
  "screenshot-region-file")
    grim -g "$(slurp)" $SCREENSHOTS_DIR/region-$(date +'%Y-%m-%dT%H-%M-%S').png && notify-send "Screenshot saved to $SCREENSHOTS_DIR"
    ;;
  "screenshot-region-clipboard")
    grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot saved to clipboard"
    ;;
  "record-screen-file")
    DELAY=3s
    notify-send "Recording in $DELAY..." --expire-time 3000 --icon camera-video
    sleep $DELAY
    wf-recorder --file=$SCREENRECORDS_DIR/screen-$(date +'%Y-%m-%dT%H-%M-%S').mp4 && notify-send "Recording saved to $SCREENRECORDS_DIR"
    ;;
  "record-region-file")
    wf-recorder -g "$(slurp)" --file=$SCREENRECORDS_DIR/region-$(date +'%Y-%m-%dT%H-%M-%S').mp4 && notify-send "Recording saved to $SCREENRECORDS_DIR"
    ;;
esac
