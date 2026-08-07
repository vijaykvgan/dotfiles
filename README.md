# dotfiles

macOS setup in one repo: the packages to install, the configuration files, and
the scripts that wire both into a fresh machine.

## Setup

git ships with the Xcode Command Line Tools, which the Homebrew installer sets
up as well, so a new machine only needs:

```sh
git clone git@github.com:vijaykvganaraju/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` runs five steps, all of which are safe to re-run. Pass names to
run only some of them, for example `./bootstrap.sh packages symlinks`.

| Step | What it does |
| --- | --- |
| `homebrew` | Installs Homebrew if `brew` is missing |
| `packages` | Installs everything in `Brewfile` |
| `herdr` | Installs herdr, which has no Homebrew formula, from its vendor script |
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
