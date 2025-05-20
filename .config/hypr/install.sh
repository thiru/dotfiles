#!/bin/sh

pacman --needed -S \
  brightnessctl \
  grim \
  hypridle \
  hyprland \
  hyprsunset \
  qt5-wayland \
  qt6-wayland \
  slurp \
  waybar \
  wf-recorder \
  xdg-desktop-portal-hyprland \
  xorg-xwayland \
  ydotool

yay --needed -S \
  walker-bin
