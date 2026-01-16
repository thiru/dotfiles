#
# Shell-agnostic config.
#

# Custom env vars
# ------------------------------------------------------------------------------

export UK_ENGLISH="English (United Kingdom).vtt"

# App-specific env vars
# ------------------------------------------------------------------------------

# Neovim - default editor
if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

# Neovide - default GUI editor
export VISUAL=neovide

# Neovim - manpage viewer
if command -v nvim &> /dev/null; then
  export MANPAGER='nvim +Man!'
fi

# Nix - Allow nix store to be a symlink
export NIX_IGNORE_SYMLINK_STORE=1

# Firefox - opt into Wayland support (otherwise xwayland will be used)
export MOZ_ENABLE_WAYLAND=1

# .NET - disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# GraalVM - home dir
if [ -d "$HOME/graalvm" ]; then
  export GRAALVM_HOME=$HOME/graalvm
fi

# musl-libc - needed by GraalVM
if [ -d "$HOME/musl-toolchain" ]; then
  export MUSL_HOME="$HOME/musl-toolchain"
fi

# FZF - use `fd` command instead of `find` when searching files with FZF:
export FZF_DEFAULT_COMMAND='fd --type f --follow'
# FZF - preview window (uses highlight package)
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"

# Ripgrep - specify config location
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc

# PATH modifications
# ------------------------------------------------------------------------------

# Cargo - add binaries to PATH
PATH="$PATH:$HOME/.cargo/bin"

# Golang - add binaries to PATH
PATH="$PATH:$HOME/go/bin"

# Add my custom scripts to PATH
PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/scripts:$HOME/scripts/clojure/src/scripts"

# Machine/user-specific config
# ------------------------------------------------------------------------------

if [ -f "$HOME/.profile.local" ]; then
  source "$HOME/.profile.local"
fi

# Other
# ------------------------------------------------------------------------------

# Set a larger font for TTYs (i.e. not virtual/pseudo terminals)
if [ "$TERM" = "linux" ]; then
  setfont ter-124n
fi

# Use this so we don't unecessarily reload this script
export MY_PROFILE_LOADED='true'
