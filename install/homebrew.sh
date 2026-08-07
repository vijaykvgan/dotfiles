#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

if load_brew; then
  ok "homebrew present ($(brew --version | head -n 1))"
  exit 0
fi

info "installing homebrew"
NONINTERACTIVE=1 /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

load_brew || die "homebrew installed but 'brew' was not found in /opt/homebrew or /usr/local"
ok "homebrew ready ($(brew --version | head -n 1))"
