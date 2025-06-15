#!/bin/sh

export TERMINAL=kitty
export PROVIDERS_FILE=$HOME/.config/sway-launcher-desktop/printscreen-provider.conf

SCREENSHOTS_DIR=~/Pictures/screen-shots
SCREENRECORDS_DIR=~/Videos/screen-recordings

case "$1" in
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
    kitty --title 'Screen Recording' --app-id launcher wf-recorder --file=$SCREENRECORDS_DIR/screen-$(date +'%Y-%m-%dT%H-%M-%S').mp4 && notify-send "Recording saved to $SCREENRECORDS_DIR"
    ;;
  "record-region-file")
    kitty --title 'Screen Recording' --app-id launcher wf-recorder -g "$(slurp)" --file=$SCREENRECORDS_DIR/region-$(date +'%Y-%m-%dT%H-%M-%S').mp4 && notify-send "Recording saved to $SCREENRECORDS_DIR"
    ;;
  *)
    kitty --title Launcher --app-id launcher --override font_size=20 sway-launcher-desktop
    ;;
esac
