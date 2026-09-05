#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

# herdr has no Homebrew formula, so it comes from the vendor install script.
if have herdr; then
  ok "herdr present ($(command -v herdr))"
  exit 0
fi

info "installing herdr from https://herdr.dev/install.sh"
curl -fsSL https://herdr.dev/install.sh | sh

if have herdr; then
  ok "herdr ready ($(command -v herdr))"
else
  warn "installer finished but 'herdr' is not on PATH in this shell"
  warn "open a new terminal, or add ~/.local/bin to PATH in home/.config/zsh/rc.zsh"
fi
