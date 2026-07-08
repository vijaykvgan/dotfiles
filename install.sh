#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_suffix="$(date +%Y%m%d%H%M%S)"

link_item() {
  local source_path="$1"
  local target_path="$2"
  local target_dir

  target_dir="$(dirname "$target_path")"
  mkdir -p "$target_dir"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'ok: %s already linked\n' "$target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    mv "$target_path" "${target_path}.backup-${backup_suffix}"
    printf 'backup: %s -> %s.backup-%s\n' "$target_path" "$target_path" "$backup_suffix"
  fi

  ln -s "$source_path" "$target_path"
  printf 'link: %s -> %s\n' "$target_path" "$source_path"
}

link_item "$repo_dir/.tmux.conf" "$HOME/.tmux.conf"
link_item "$repo_dir/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link_item "$repo_dir/.config/nvim" "$HOME/.config/nvim"
