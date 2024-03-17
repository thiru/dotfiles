#!/bin/sh

curr_shell=`ps -p $$ | tail -1 | awk '{print $NF}'`

alias dn='dotnet'
alias g='git'
alias rename-vim='vidir'

if command -v exa &> /dev/null; then
  alias l='exa -l'
  alias lg='exa -l --git'
  alias ll='exa -la'
  alias lt='exa --tree'
  alias lw='exa'
else
  alias l='ls -l'
  alias ll='ls -la'
fi

alias sc='systemctl'

if command -v nvim &> /dev/null; then
  alias v='nvim'
  alias vt='nvim --cmd "lua vim.g.plain_term = true"'
else
  alias v='vim'
fi

alias disks='lsblk -o +LABEL,PARTLABEL,UUID,PARTUUID'
alias assh='TERM=xterm-256color ssh'

if [ $curr_shell = "zsh" ]; then
  compdef g=git
  compdef sc=systemctl
  if command -v nvim &> /dev/null; then
    compdef v=nvim
  else
    compdef v=vim
  fi
fi

# The following will allow sudo to find aliases
alias sudo='sudo '

