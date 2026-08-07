#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

zshrc="$HOME/.zshrc"
marker='.config/zsh/rc.zsh'

touch "$zshrc"

if grep -qF "$marker" "$zshrc"; then
  ok "~/.zshrc already sources ~/$marker"
  exit 0
fi

info "hooking ~/$marker into ~/.zshrc"
cat >> "$zshrc" <<'EOF'

# dotfiles: all shell configuration lives in the repo, edit that file instead.
[ -r "$HOME/.config/zsh/rc.zsh" ] && source "$HOME/.config/zsh/rc.zsh"
EOF
ok "~/.zshrc updated"
