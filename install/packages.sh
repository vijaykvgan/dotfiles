#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

load_brew || die "homebrew is missing, run ./bootstrap.sh homebrew first"

info "installing everything in Brewfile"
if brew bundle install --file "$DOTFILES_ROOT/Brewfile"; then
  ok "all Brewfile entries installed"
else
  warn "some Brewfile entries failed, see the summary above"
  warn "re-run with: brew bundle install --file $DOTFILES_ROOT/Brewfile"
fi
