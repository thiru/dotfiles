#!/bin/sh

# Aliases for POSIX-compliant shells (not fish)

curr_shell=`ps -p $$ | tail -1 | awk '{print $NF}'`

# Simple
alias g='git'
alias nv='neovide'
alias sc='systemctl'
alias z='zathura'

# Directory listing
if command -v exa &> /dev/null; then
  alias l='exa -l'
  alias lg='exa -l --git'
  alias ll='exa -la'
  alias lt='exa --tree'
else
  alias l='ls -l'
  alias ll='ls -la'
fi

# Vim/Neovim
if command -v nvim &> /dev/null; then
  alias v='nvim'
else
  alias v='vim'
fi

# Zsh-specific
if [ $curr_shell = "zsh" ]; then
  compdef g=git
  compdef sc=systemctl
  compdef z=zathura
  if command -v nvim &> /dev/null; then
    compdef v=nvim
  else
    compdef v=vim
  fi
fi

# The following will allow sudo to find aliases
alias sudo='sudo '
