#!/bin/sh

export TERMINAL=kitty
export PROVIDERS_FILE=$HOME/.config/sway-launcher-desktop/power-provider.conf

kitty --title Launcher --app-id launcher --override font_size=22 sway-launcher-desktop
