#!/bin/sh

export TERMINAL=kitty
export PROVIDERS_FILE=$HOME/.config/sway-launcher-desktop/pass-provider.conf

kitty --title Launcher --app-id launcher sway-launcher-desktop
