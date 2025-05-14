#!/usr/bin/env bash

# Open file with FZF

to_open=~/.cache/fzf-open-file

if [ $# -lt 1 ]; then
  echo "Usage: fzf-open.sh [search|open]"
  exit 1
elif [ "$1" = "search" ]; then
  file=$(fzf --preview 'fzf-preview.sh {}')
  abs_file=$(readlink -f "$file")
  echo "$abs_file" > "$to_open"
elif [ "$1" = "open" ]; then
  file=$(cat "$to_open")
  type=$(file --brief --dereference --mime -- "$file")

  if [[ $type =~ text/ ]]; then
    neovide "$file"
  elif [[ $type =~ image/ ]]; then
    imv "$file"
  else
    xdg-open "$file"
  fi

  rm "$to_open"
else
  echo "Unexpected sub-command"
  exit 1
fi
