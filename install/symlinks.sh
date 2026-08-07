#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

home_src="$DOTFILES_ROOT/home"
backup_suffix="$(date +%Y%m%d%H%M%S)"

# Everything in home/ is linked into $HOME at the same relative path. Top level
# entries are linked as-is, while .config is linked one level deeper so that
# unmanaged tools can still create their own directories under ~/.config.
collect_targets() {
  local path name
  shopt -s dotglob nullglob
  for path in "$home_src"/*; do
    name="${path##*/}"
    [ "$name" = ".config" ] && continue
    [ "$name" = ".DS_Store" ] && continue
    printf '%s\n' "$name"
  done
  for path in "$home_src"/.config/*; do
    name="${path##*/}"
    [ "$name" = ".DS_Store" ] && continue
    printf '.config/%s\n' "$name"
  done
  shopt -u dotglob nullglob
}

link() {
  local rel="$1"
  local src="$home_src/$rel"
  local dest="$HOME/$rel"

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      ok "~/$rel"
      return
    fi
    rm "$dest"
    ln -s "$src" "$dest"
    ok "~/$rel (relinked, was $current)"
    return
  fi

  if [ -e "$dest" ]; then
    mv "$dest" "$dest.backup-$backup_suffix"
    warn "existing ~/$rel moved to ~/$rel.backup-$backup_suffix"
  fi

  ln -s "$src" "$dest"
  ok "~/$rel"
}

info "linking home/ into $HOME"
while IFS= read -r rel; do
  link "$rel"
done < <(collect_targets)
