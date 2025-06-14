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

function set-nvim-window-title --on-variable PWD --description "Set Neovim title to PWD"
  set -l curr_dir (string replace -r "^$HOME" '~' (pwd))

  if set -q NVIM
    nvim --server $NVIM --remote-send "<cmd>lua vim.opt.titlestring='$curr_dir'<CR>"
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

# Startup
# --------

if status is-interactive
   # Suppress greeting
  set fish_greeting

  set-nvim-window-title

  # Enable vi mode
  fish_vi_key_bindings

  # fzf key bindings
  fzf --fish | source

  set-abbreviations
  set-keybinds

  # Starship prompt
  starship init fish | source
end
