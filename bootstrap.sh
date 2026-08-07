#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)/common.sh"

ALL_STEPS=(homebrew packages herdr symlinks zsh)

usage() {
  cat <<EOF
Usage: ./bootstrap.sh [step ...]

Runs every step in order when called without arguments. Each step is safe to
re-run.

Steps:
  homebrew   install Homebrew if it is missing
  packages   install everything listed in Brewfile
  herdr      install herdr from https://herdr.dev/install.sh
  symlinks   link home/ into \$HOME
  zsh        make ~/.zshrc load the shell config from this repo
EOF
}

case "${1-}" in
  -h|--help) usage; exit 0 ;;
esac

steps=("$@")
[ ${#steps[@]} -eq 0 ] && steps=("${ALL_STEPS[@]}")

for step in "${steps[@]}"; do
  script="$DOTFILES_ROOT/install/$step.sh"
  [ -f "$script" ] || { usage; die "unknown step: $step"; }
  bash "$script"
done

ok "done, open a new terminal to pick up shell changes"
