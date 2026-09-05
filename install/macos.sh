#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

if [ "$(uname -s)" != "Darwin" ]; then
  warn "skipping macos defaults on $(uname -s)"
  exit 0
fi

info "applying Dock defaults"

# Position and size
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 46

# Auto-hide (instant + fast animation)
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Magnification off
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock largesize -int 48

# Minimize behavior
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock minimize-to-application -bool false

# Indicators
defaults write com.apple.dock show-process-indicators -bool true

# Bottom-right hot corner off (1 = none; clears a prior Quick Note binding)
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

killall Dock
ok "Dock restarted"
