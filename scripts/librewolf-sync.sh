#!/bin/sh

# Script to sync Librewolf profile to/from RAM/disk
# Ref: https://wiki.archlinux.org/title/Firefox/Profile_on_RAM

profile=$1
static=static-$profile
link=$profile
volatile=/dev/shm/librewolf-$profile-$USER

IFS=
set -efu

cd ~/.librewolf

if [ ! -r $volatile ]; then
  mkdir -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
  mv $link $static
  ln -s $volatile $link
fi

if [ -e $link/.unpacked ]; then
  rsync -av --delete --exclude .unpacked ./$link/ ./$static/
else
  rsync -av ./$static/ ./$link/
  touch $link/.unpacked
fi
