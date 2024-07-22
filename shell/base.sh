#!/bin/bash

# This script contains shell-agnostic configs

if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

export VISUAL=neovide

# Allow nix store to be a symlink
export NIX_IGNORE_SYMLINK_STORE=1

# Custom, machine-specific environment variables
if [ -f "$HOME/.config/env-vars" ]; then
  source "$HOME/.config/env-vars"
fi

# Opt into Wayland support for Firefox (otherwise xwayland will be used)
export MOZ_ENABLE_WAYLAND=1

# Cargo binaries
PATH="$PATH:$HOME/.cargo/bin"

# Zsh plugin for nix-shell
if [ -d "/usr/share/zsh/plugins/zsh-nix-shell" ]; then
  source "/usr/share/zsh/plugins/zsh-nix-shell/nix-shell.plugin.zsh"
fi

# Local binaries and scripts
PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/software-configs/scripts/linux:$HOME/software-configs/scripts/clojure/src/scripts"

# Work scripts
if [ -d "$HOME/code/work/configs/bin" ]; then
  PATH="$PATH:$HOME/code/work/configs/bin"
fi

# GraalVM home
if [ -d ~/graalvm ]; then
  export GRAALVM_HOME=$HOME/graalvm
fi

# NNN
export NNN_OPTS="e"

# FZF

# Use `fd` command instead of `find` when searching files with FZF:
export FZF_DEFAULT_COMMAND='fd --type f --follow'
# Full-screen mode
export FZF_DEFAULT_OPTS='--no-height --no-reverse'
# Preview window (uses highlight package)
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"

# Set a larger font for (non-virtual) TTYs
if [ "$TERM" = "linux" ]; then
  setfont ter-124n
fi

# Start SSH agent and ensure that only one runs at a time:
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
  source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
