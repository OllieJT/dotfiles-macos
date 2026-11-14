export HOMEBREW_CASK_OPTS="--no-quarantine"
HIST_STAMPS="dd/mm/yyyy"

function exists() {
  command -v $1 >/dev/null 2>&1
}

. "$HOME/.cargo/env"
