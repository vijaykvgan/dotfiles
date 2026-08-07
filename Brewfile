# Everything installed on a new machine. Apply with `brew bundle --file Brewfile`
# or `./bootstrap.sh packages`.

# --- Command line ---------------------------------------------------------
brew "git"                            # clone and update this repo
brew "maven"                          # Java project builds
brew "neovim"                         # editor, configured in home/.config/nvim
brew "tmux"                           # terminal session management
brew "kubernetes-cli"                 # kubectl, for managing containers remotely
brew "jq"                             # high performance JSON parsing on the CLI
brew "ripgrep"                        # fast recursive search, rg
brew "fzf"                            # fuzzy finder for files, history, anything piped in
brew "nvm"                            # Node Version Manager
brew "python"                         # latest Python 3
brew "zsh-autocomplete"               # fish-like as-you-type completion
brew "zsh-syntax-highlighting"        # colors invalid commands before you run them

# --- Applications ---------------------------------------------------------
cask "ghostty"                        # terminal emulator
cask "maccy"                          # clipboard history, recommended by Anish Varsha Iska
cask "rectangle"                      # keyboard window management
cask "postman"                        # API client

# --- Java -----------------------------------------------------------------
# Azul Zulu is used over other OpenJDK builds for its coverage of old and new
# releases under one license: https://www.azul.com/products/core/jdk-comparison-matrix
# Pick a default with, for example:
#   echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' >> ~/.zshrc
cask "zulu@8"                         # legacy projects
cask "zulu@21"                        # current LTS
cask "zulu@25"                        # latest LTS
