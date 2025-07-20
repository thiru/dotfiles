#!/usr/bin/env bash

# Install LSP servers on Arch

sudo pacman -S --needed \
  bash-language-server \
  deno \
  gopls \
  lua-language-server \
  pyright \
  vscode-css-languageserver \
  vscode-html-languageserver \
  vscode-json-languageserver

yay -S --needed \
  clojure-lsp-bin \
  jdtls
