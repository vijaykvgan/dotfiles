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
links `home/`. Linux installs herdr, links `home/`, and hooks zsh. Pass names
to run specific steps, for example `./bootstrap.sh macos` or
`./bootstrap.sh symlinks`.

| Step | What it does |
| --- | --- |
| `homebrew` | Installs Homebrew if `brew` is missing (Darwin default) |
| `packages` | Installs everything in `Brewfile`, plus the `Brewfile.optional` entries you say yes to (Darwin default) |
| `sdkman` | Installs SDKMAN and Zulu 21 as the default Java (Darwin default) |
| `herdr` | Installs herdr from its vendor script (Darwin default) |
| `macos` | Dock `defaults` on Darwin; no-op elsewhere |
| `linux` | Installs herdr on Linux; its tracked config is linked by `symlinks` |
| `symlinks` | Links `home/` into `$HOME` |
| `zsh` | Makes `~/.zshrc` source the shell config in this repo |

## Layout

```
Brewfile          packages and applications to install
Brewfile.optional extras, asked about one by one before installing
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
| `home/.config/ghostty` | `~/.config/ghostty` |

herdr is linked as a file, not a directory: it writes logs, sockets, and
`session.json` into `~/.config/herdr` at runtime.

herdr is installed on both macOS and Linux and uses the same keybindings on
each. Ghostty's default shortcuts differ per OS and would otherwise take some
of those keys first: Option+arrows on macOS, and Alt+1-9, Ctrl+Alt+arrows, and
Ctrl+Shift+arrows on Linux. `home/.config/ghostty/config` unbinds them and
turns on Option as Alt for macOS.

Adding a new config file means dropping it under `home/` and re-running
`./bootstrap.sh symlinks`. Anything already at the destination is moved aside to
a `.backup-<timestamp>` copy first.

## Shell

`~/.zshrc` holds a single line that sources `home/.config/zsh/rc.zsh`, which
puts Homebrew on `PATH`, loads `zsh-autocomplete` and `zsh-syntax-highlighting`,
loads SDKMAN, and starts the [Starship](https://starship.rs) prompt, which shows
the git branch and status. Without Starship installed it falls back to a plain
prompt with the branch, `*` for unstaged and `+` for staged changes. No
framework such as Oh My Zsh is involved.

fzf provides `Ctrl-R` for history, `Ctrl-T` for files, and `Alt-C` to jump into a
directory, using ripgrep to list files so that `.gitignore` is respected. It is
loaded after `zsh-autocomplete`, which also wants `Ctrl-R`, so the last one
sourced wins. Swap that order in `rc.zsh` to get the autocomplete menu back.

## Java

Java comes from [SDKMAN](https://sdkman.io), not Homebrew. The `sdkman` step
installs it and makes the newest Azul Zulu 21 build the default, and `rc.zsh`
loads it, which also sets `JAVA_HOME`. Azul Zulu is used over other OpenJDK
builds for its coverage of old and new releases under one license:
https://www.azul.com/products/core/jdk-comparison-matrix

```sh
sdk list java | grep zulu        # available Zulu builds
sdk install java <version>-zulu  # add another, e.g. 8 or 25
sdk use java <version>-zulu      # this shell only
sdk default java <version>-zulu  # every new shell
```

## OS defaults

`install/macos.sh` writes Dock preferences that `defaults` does not keep as files
under `home/`. Re-run with `./bootstrap.sh macos`. The Dock restarts at the end
of the step.

`install/linux.sh` installs herdr using the same vendor installer as the
explicit `herdr` step. The following `symlinks` step links your tracked
`home/.config/herdr/config.toml` into `~/.config/herdr/config.toml`, while
preserving the runtime files that herdr writes in that directory. GUI apps stay
in the macOS `Brewfile` and are not part of this layer.
