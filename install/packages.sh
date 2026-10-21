#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

load_brew || die "homebrew is missing, run ./bootstrap.sh homebrew first"

optional="$DOTFILES_ROOT/Brewfile.optional"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# One combined Brewfile: everything in Brewfile plus the optional entries you
# said yes to. All questions come first so the install itself runs unattended.
cp "$DOTFILES_ROOT/Brewfile" "$work/Brewfile"
printf '\n' >>"$work/Brewfile"

if [ ! -f "$optional" ]; then
  :
elif [ ! -t 0 ]; then
  warn "no terminal to ask from, skipping everything in Brewfile.optional"
else
  info "choosing optional packages from Brewfile.optional"
  # The file is read on fd 3 so that `read answer` still gets the keyboard.
  while IFS= read -r line <&3; do
    case "$line" in
      brew\ \"*) flag=--formula ;;
      cask\ \"*) flag=--cask ;;
      *) continue ;;
    esac
    name="${line#*\"}"
    name="${name%%\"*}"
    note=""
    case "$line" in *"# "*) note=" (${line#*# })" ;; esac

    if brew list "$flag" "$name" >/dev/null 2>&1; then
      ok "$name already installed"
      continue
    fi

    printf '    install %s%s? [y/N] ' "$name" "$note"
    read -r answer || answer=""
    case "$answer" in
      [yY]*) printf '%s\n' "$line" >>"$work/Brewfile" ;;
    esac
  done 3<"$optional"
fi

info "installing everything in Brewfile"
if brew bundle install --file "$work/Brewfile"; then
  ok "all Brewfile entries installed"
else
  warn "some Brewfile entries failed, see the summary above"
  warn "re-run with: ./bootstrap.sh packages"
fi
