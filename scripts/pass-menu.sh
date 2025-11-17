#!/bin/sh

PASS_DIR=~/.password-store

SELECTION=$(fd .gpg "$PASS_DIR" | sed 's:.*/.password-store/\(.*\)\.gpg:\1:g' | fzf --style full)

if [ -n "$SELECTION" ]; then
  pass show "${SELECTION}" | nohup wl-copy > /dev/null 2>&1
  notify-send "Copied ${SELECTION}" --expire-time 1500 --icon edit-copy
fi
