#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

export SDKMAN_DIR="${SDKMAN_DIR:-$HOME/.sdkman}"
java_major=21

if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  ok "sdkman present"
else
  info "installing sdkman"
  # rcupdate=false: rc.zsh already loads SDKMAN, so keep it out of ~/.zshrc.
  curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash
fi

# sdkman-init.sh and the sdk function reference unset variables.
set +u
# shellcheck source=/dev/null
source "$SDKMAN_DIR/bin/sdkman-init.sh"

if compgen -G "$SDKMAN_DIR/candidates/java/$java_major.*-zulu" >/dev/null; then
  current="$(readlink "$SDKMAN_DIR/candidates/java/current" || true)"
  ok "zulu $java_major already installed (default: ${current##*/})"
  exit 0
fi

# Newest Zulu build for the major version, skipping the JavaFX (.fx) variants.
version="$(sdk list java | grep -oE "\b$java_major\.[0-9.+]+-zulu\b" | head -n 1)"
[ -n "$version" ] || die "no zulu $java_major build found in 'sdk list java'"

info "installing java $version"
# No stdin means the "make this the default?" prompt takes its default, yes.
sdk install java "$version" </dev/null
ok "java $version installed and set as default"
