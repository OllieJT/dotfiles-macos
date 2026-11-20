#!/usr/bin/env bash
echo "Loaded .bashrc"

# END
eval "$(starship init bash)"
. "$HOME/.cargo/env"
PATH=~/.console-ninja/.bin:$PATH


# Added by Antigravity CLI installer
export PATH="/Users/olliejt/.local/bin:$PATH"
