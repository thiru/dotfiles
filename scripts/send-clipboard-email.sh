#!/usr/bin/env bash

set -euo pipefail

die() {
  printf 'send-clipboard-email: %s\n' "$*" >&2
  exit 1
}

command -v hey >/dev/null 2>&1 || die "hey CLI is not installed or not on PATH"

read_clipboard() {
  if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-paste >/dev/null 2>&1; then
    wl-paste --no-newline
  elif [[ -n "${DISPLAY:-}" ]] && command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -out
  elif [[ -n "${DISPLAY:-}" ]] && command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --output
  elif command -v wl-paste >/dev/null 2>&1; then
    wl-paste --no-newline
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -out
  elif command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --output
  else
    die "install wl-clipboard, xclip, or xsel to read the clipboard"
  fi
}

# The sentinel keeps command substitution from stripping trailing newlines.
clipboard="$(read_clipboard && printf '\001')" || die "could not read clipboard"
clipboard="${clipboard%$'\001'}"
[[ -n "$clipboard" ]] || die "clipboard is empty"

command -v jq >/dev/null 2>&1 || die "jq is required to determine your HEY address"
senders=$(hey account senders --json --quiet) || die "could not list HEY sender addresses"
recipient=$(jq -er '
  [.[] | select(.default == true)] as $defaults |
  if ($defaults | length) == 1 then $defaults[0].email
  elif length == 1 then .[0].email
  else error("multiple sender addresses; no unique default")
  end
' <<<"$senders") || die "could not determine a unique HEY sender address"

subject="Clipboard $(date '+%Y-%m-%d %H:%M')"
printf '%s' "$clipboard" | hey compose --to "$recipient" --subject "$subject"
