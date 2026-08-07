#!/usr/bin/env bash
# Shared helpers sourced by bootstrap.sh and the install/ scripts.

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_ROOT

if [ -t 1 ]; then
  _c_blue=$'\033[34m'; _c_green=$'\033[32m'; _c_yellow=$'\033[33m'
  _c_red=$'\033[31m'; _c_reset=$'\033[0m'
else
  _c_blue=""; _c_green=""; _c_yellow=""; _c_red=""; _c_reset=""
fi

info() { printf '%s==>%s %s\n' "$_c_blue" "$_c_reset" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$_c_green" "$_c_reset" "$*"; }
warn() { printf '%s  !!%s %s\n' "$_c_yellow" "$_c_reset" "$*" >&2; }
die()  { printf '%serror%s %s\n' "$_c_red" "$_c_reset" "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# Homebrew is not on PATH in a fresh shell right after install, so look in the
# standard prefixes before giving up.
load_brew() {
  have brew && return 0
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      eval "$("$candidate" shellenv)"
      return 0
    fi
  done
  return 1
}
