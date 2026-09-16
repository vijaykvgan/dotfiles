#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

if [ "$(uname -s)" != "Linux" ]; then
  warn "skipping Linux setup on $(uname -s)"
  exit 0
fi

# symlinks.sh runs next and links config.toml without replacing herdr runtime state.
info "installing Linux terminal workspace tools"
bash "$DOTFILES_ROOT/install/herdr.sh"

ok "Linux setup complete"
