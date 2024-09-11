#!/bin/bash

# Creates a directory and changes to it
# (forgot where I got this from)
function mkcd
{
  case "$1" in
    */..|*/../) cd -- "$1";; # that doesn't make any sense unless the directory already exists
    /*/../*) (cd "${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd -- "$1";;
    /*) mkdir -p "$1" && cd "$1";;
    */../*) (cd "./${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd "./$1";;
    ../*) (cd .. && mkdir -p "${1#.}") && cd "$1";;
    *) mkdir -p "./$1" && cd "./$1";;
  esac
}

# Move up N directories
# (c) 2007 stefan w. GPLv3
function up
{
  ups=""
  for i in $(seq 1 $1)
  do
    ups=$ups"../"
  done
  cd $ups
}

# Go to directory via `fzf` and `fd`
cdfzf() {
  local dir
  dir=$(fd --follow --type directory . "$HOME" | fzf --no-multi) &&
  cd "$dir" || exit
  reset
}

