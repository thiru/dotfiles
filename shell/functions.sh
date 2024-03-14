#!/bin/sh

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
  dir=$(fd --follow --type directory | fzf --no-multi) &&
  cd "$dir"
}

# Go to directory via `lf`
cdlf () {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}

# Go to directory and open file (if applicable)
cdopen() {
  local dir_or_file=$(fd --follow | fzf --no-multi)
  dir_or_file=$(realpath -s "$dir_or_file")
  cd "$dir_or_file" # even if this is a file Zsh will cd to the parent dir
  if [ -f "$dir_or_file" ]; then
    $EDITOR $dir_or_file
  fi
}
