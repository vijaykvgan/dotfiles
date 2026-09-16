#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)/common.sh"

# Shared configs always run. Packages and GUI apps are Darwin-only by default.
# OS setup lives in install/macos.sh and install/linux.sh.
default_steps() {
  case "$(uname -s)" in
    Darwin)
      printf '%s\n' homebrew packages herdr macos symlinks zsh
      ;;
    Linux)
      [ -f "$DOTFILES_ROOT/install/linux.sh" ] && printf '%s\n' linux
      printf '%s\n' symlinks zsh
      ;;
    *)
      warn "unknown OS $(uname -s), linking configs only"
      printf '%s\n' symlinks zsh
      ;;
  esac
}

usage() {
  cat <<EOF
Usage: ./bootstrap.sh [step ...]

With no arguments, runs the default steps for this OS. Each step is safe to
re-run. Named steps work on any OS (macos no-ops off Darwin).

Defaults:
  Darwin   homebrew packages herdr macos symlinks zsh
  Linux    linux (installs herdr) symlinks zsh

Steps:
  homebrew   install Homebrew if it is missing
  packages   install everything listed in Brewfile
  herdr      install herdr from https://herdr.dev/install.sh
  macos      Dock position, auto-hide, and related defaults (Darwin)
  linux      install Linux terminal workspace tools
  symlinks   link home/ into \$HOME
  zsh        make ~/.zshrc load the shell config from this repo
EOF
}

case "${1-}" in
  -h|--help) usage; exit 0 ;;
esac

steps=("$@")
if [ ${#steps[@]} -eq 0 ]; then
  while IFS= read -r step; do
    steps+=("$step")
  done < <(default_steps)
fi

for step in "${steps[@]}"; do
  script="$DOTFILES_ROOT/install/$step.sh"
  [ -f "$script" ] || { usage; die "unknown step: $step"; }
  bash "$script"
done

ok "done, open a new terminal to pick up shell changes"
