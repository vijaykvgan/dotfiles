# Shell configuration, symlinked to ~/.config/zsh/rc.zsh by the dotfiles repo.
# ~/.zshrc only sources this file, so keep changes here to have them tracked.

# Homebrew has to come first, the plugins below live under its prefix.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x $_brew ]]; then
    eval "$($_brew shellenv)"
    break
  fi
done
unset _brew

# Default Node on PATH without sourcing nvm.sh. `nvm` itself is lazy-loaded.
export NVM_DIR="$HOME/.nvm"
_nvm_ref=
[[ -r $NVM_DIR/alias/default ]] && _nvm_ref=$(<"$NVM_DIR/alias/default")
_nvm_i=0
while (( ++_nvm_i <= 8 )) && [[ -n $_nvm_ref && -r "$NVM_DIR/alias/$_nvm_ref" ]]; do
  _nvm_ref=$(<"$NVM_DIR/alias/$_nvm_ref")
done
_nvm_bin="$NVM_DIR/versions/node/${_nvm_ref}/bin"
[[ -d $_nvm_bin ]] && path=("$_nvm_bin" $path)
unset _nvm_ref _nvm_i _nvm_bin

nvm() {
  unset -f nvm
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \
    source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}

# Fish-like completion as you type.
if [[ -r $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Gray suggestion from history, accepted with the right arrow key.
if [[ -r $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Ctrl-R history, Ctrl-T files, Alt-C directories. Sourced after
# zsh-autocomplete so that fzf owns Ctrl-R rather than the autocomplete menu.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  if (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob !.git/*'
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  fi
fi

# Branch name in the prompt, with * for unstaged and + for staged changes.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b|%a%u%c%f'
precmd_functions+=(vcs_info)
setopt prompt_subst
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %# '

# Must stay last, it wraps every widget defined before it.
if [[ -r $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
