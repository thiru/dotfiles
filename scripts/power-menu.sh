#!/bin/sh

export TERMINAL=kitty
export PROVIDERS_FILE=$HOME/.config/sway-launcher-desktop/power-providers.conf

kitty --title Launcher --app-id launcher --override font_size=24 sway-launcher-desktop
