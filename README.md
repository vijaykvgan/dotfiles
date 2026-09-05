# dotfiles

Shared shell/editor configs in one repo, plus a small OS-defaults script per
platform. Homebrew packages and GUI apps are a macOS convenience, not the Linux
path.

## Setup

```sh
git clone git@github.com:vijaykvganaraju/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

With no arguments, Darwin installs packages and applies Dock defaults, then
links `home/`. Linux only links `home/` and hooks zsh. Pass names to run
specific steps, for example `./bootstrap.sh macos` or `./bootstrap.sh symlinks`.

| Step | What it does |
| --- | --- |
| `homebrew` | Installs Homebrew if `brew` is missing (Darwin default) |
| `packages` | Installs everything in `Brewfile` (Darwin default) |
| `herdr` | Installs herdr from its vendor script (Darwin default) |
| `macos` | Dock `defaults` on Darwin; no-op elsewhere |
| `linux` | Linux desktop defaults, if `install/linux.sh` is present |
| `symlinks` | Links `home/` into `$HOME` |
| `zsh` | Makes `~/.zshrc` source the shell config in this repo |

## Layout

```
Brewfile          packages and applications to install
bootstrap.sh      entry point, runs the steps below
install/          one script per step
lib/common.sh     logging and Homebrew helpers
home/             files linked into $HOME at the same relative path
```

Everything under `home/` is a symlink target, so editing `~/.config/nvim/init.lua`
edits the file in this repo and `git status` picks it up. Top level entries are
linked directly, and `~/.config` entries are linked one level deeper so other
tools can keep writing their own directories there.

| Repo path | Link |
| --- | --- |
| `home/.tmux.conf` | `~/.tmux.conf` |
| `home/.config/tmux` | `~/.config/tmux` |
| `home/.config/nvim` | `~/.config/nvim` |
| `home/.config/zsh` | `~/.config/zsh` |
| `home/.config/herdr/config.toml` | `~/.config/herdr/config.toml` |

herdr is linked as a file, not a directory: it writes logs, sockets, and
`session.json` into `~/.config/herdr` at runtime.

Adding a new config file means dropping it under `home/` and re-running
`./bootstrap.sh symlinks`. Anything already at the destination is moved aside to
a `.backup-<timestamp>` copy first.

## Shell

`~/.zshrc` holds a single line that sources `home/.config/zsh/rc.zsh`, which
puts Homebrew on `PATH`, loads `zsh-autocomplete` and `zsh-syntax-highlighting`,
and sets a prompt showing the current git branch with `*` for unstaged and `+`
for staged changes. No framework such as Oh My Zsh is involved.

fzf provides `Ctrl-R` for history, `Ctrl-T` for files, and `Alt-C` to jump into a
directory, using ripgrep to list files so that `.gitignore` is respected. It is
loaded after `zsh-autocomplete`, which also wants `Ctrl-R`, so the last one
sourced wins. Swap that order in `rc.zsh` to get the autocomplete menu back.

## Java

The `Brewfile` installs Zulu 8, 21, and 25. Choose a default with:

```sh
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' >> ~/.config/zsh/rc.zsh
```

## OS defaults

`install/macos.sh` writes Dock preferences that `defaults` does not keep as files
under `home/`. Re-run with `./bootstrap.sh macos`. The Dock restarts at the end
of the step.

Linux does not get a stand-in for the Dock. Add `install/linux.sh` when there
are real desktop settings to apply; bootstrap will pick it up on Linux
automatically. GUI apps stay in the macOS `Brewfile` and are not part of this
layer.
