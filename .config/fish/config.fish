#!/usr/bin/env fish

# Functions
# ----------

function cdfzf --description "Go to directory in $HOME via fzf and fd"
  set -l dir (fd --follow --type directory . $HOME | fzf --no-multi)
  if test -n "$dir"
    cd "$dir"
    commandline -f repaint
  end
end

function mkcd --description "Create a directory and cd into it"
  switch "$argv[1]"
    case '*/..' '*/../'
      # that doesn't make any sense unless the directory already exists
      cd -- "$argv[1]"
    case '/*/../*'
      cd (string replace -r '/[^/]*$' '' -- "$argv[1]/..") && mkdir -p "./"(string replace -r '^.*/\.\./' '' -- "$argv[1]") && cd -- "$argv[1]"
    case '/*'
      mkdir -p "$argv[1]" && cd "$argv[1]"
    case '*/../*'
      cd "./"(string replace -r '/[^/]*$' '' -- "$argv[1]/..") && mkdir -p "./"(string replace -r '^.*/\.\./' '' -- "$argv[1]") && cd "./$argv[1]"
    case '../*'
      cd .. && mkdir -p (string replace -r '^\.\.' '' -- "$argv[1]") && cd "$argv[1]"
    case '*'
      mkdir -p "./$argv[1]" && cd "./$argv[1]"
  end
end

function priv-mode-toggle
  if test -n "$fish_private_mode"
    set --erase fish_private_mode
    echo "Private mode off"
  else
    set --global fish_private_mode 1
    echo 'Private mode on'
  end
end

function set-abbreviations
  # Directory listings
  if command -v exa &> /dev/null
    abbr -a l 'exa -l'
    abbr -a lg 'exa -l --git'
    abbr -a ll 'exa -la'
    abbr -a lt 'exa --tree'
  else
    abbr -a l 'ls -l'
    abbr -a ll 'ls -la'
  end

  # Vim/Neovim
  if command -v nvim &> /dev/null
    abbr -a v 'nvim'
  else
    abbr -a v 'vim'
  end

  # Other
  abbr -a g 'git'
  abbr -a nv 'neovide'
  abbr -a pm 'sudo pacman'
  abbr -a sc 'systemctl'
  abbr -a z 'zathura'
end

function set-keybinds
  # Go to directory
  bind -M insert \cg 'cdfzf'

  # Previous/next command
  bind -M insert \ck 'up-or-search'
  bind -M insert \cj 'down-or-search'

  # Accept complete fish suggestion
  bind -M insert \co forward-char

  # Toggle private mode
  bind -M insert \cp 'priv-mode-toggle'
end

function my_postexec --on-event fish_postexec --description "Update git branch in Neovim"
  if test $status -eq 0 && set -q NVIM
    # Git branch
    set -l git_branch (git branch --show-current 2>/dev/null)
    if test -n "$git_branch"
      nvim --server $NVIM --remote-send "<CMD>lua require('nvtmux').set_git_branch('$git_branch')<CR>"
    else
      nvim --server $NVIM --remote-send "<CMD>lua require('nvtmux').set_git_branch('')<CR>"
    end
  end
end

function set-nvim-title-and-cwd --on-variable PWD --description "Set Neovim title and CWD to PWD"
  if set -q NVIM
    set -l curr_dir (string replace -r "^$HOME" '~' (pwd))
    nvim --server $NVIM --remote-send "<CMD>lua require('nvtmux').update_cwd('$curr_dir')<CR>"
  end
end

function up --description "Move up one or more directories"
  set ups ""
  for i in (seq 1 $argv[1])
    set ups $ups"../"
  end
  cd $ups
end

function y --description "Go to directory with yazi"
  set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"

  if set -l cwd (cat "$tmp")
    if test -n "$cwd" && test "$cwd" != "$PWD"
      cd -- "$cwd"
    end
  end

  rm -f -- "$tmp"
end

function loadenv --description 'Load .env file'
  if test -f $argv[1]
    for line in (cat $argv[1] | grep -v '^#' | grep -v '^$')
      set -gx (echo $line | cut -d= -f1) (echo $line | cut -d= -f2-)
    end
  end
end

function fish_mode_prompt
  # NOTE: this empty function is to simply hide the vi mode indicator in the prompt
end

function fish_prompt
  # Show exit code if last command failed
  set -l last_status $status
  if test $last_status -ne 0
    set_color red
    echo -n "[$last_status] "
  end

  # Don't show CWD and branch if we're running inside a Neovim instance. In this case we assume
  # that we're running inside a Neovim terminal and that the CWD will be shown elsewhere, e.g. as
  # part of a lualine component.
  if not string length -q -- "$NVIM"
    # Current directory (truncated)
    set_color cyan
    echo -n (prompt_pwd)

    # Git branch set -l git_branch (git branch --show-current 2>/dev/null)
    if test -n "$git_branch"
      set_color magenta
      echo -n "$git_branch "
    end

    echo ''
  end

  # Prompt symbol
  set_color normal
  echo -n '❯ '
end

# Usage
loadenv .env

# Startup
# --------

if status is-interactive
   # Suppress greeting
  set fish_greeting

  loadenv ~/.env

  set-nvim-title-and-cwd

  # Enable vi mode
  fish_vi_key_bindings

  # fzf key bindings
  fzf --fish | source

  set-abbreviations
  set-keybinds
end
