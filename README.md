# dotfiles

Personal dotfiles for tmux and Neovim.

## Layout

- `.tmux.conf`: user tmux config loaded from `$HOME/.tmux.conf`
- `.config/tmux/tmux.conf`: XDG tmux config loaded from `$HOME/.config/tmux/tmux.conf`
- `.config/nvim`: Neovim config loaded from `$HOME/.config/nvim`

## Install

Run from the repo root:

```sh
./install.sh
```

The installer creates symlinks into `$HOME`. If a target already exists and is not the expected symlink, it is moved to a timestamped backup path first.
