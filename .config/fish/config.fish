#!/usr/bin/env fish

source (dirname (path resolve (status --current-filename)))/utils.fish

# load env vars in start-up cwd
loadenv .env

if status is-interactive
   # Suppress greeting
  set fish_greeting

  # load user-global env vars
  loadenv ~/.env

  # enable vi mode
  fish_vi_key_bindings

  # fzf key bindings
  fzf --fish | source

  abbreviations-setup
  keybinds-setup
end
