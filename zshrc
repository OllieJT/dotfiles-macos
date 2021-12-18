echo "Loaded .zshrc"

# Set Variables
## Bat syntax highlighting for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"

# Change zshrc

# Create Aliases
# alias ls="ls -lAFh"
alias ls="exa -laFh --git"
alias update-brewfile="cd ~/.dotfiles && brew bundle dump --force --describe && echo 'Brewfile updated ✅'"

# Customize PS1 Prompt(s)
PROMPT="
%1~ %L %#"

RPROMPT="%*"

# Add locations to $PATH variable
## Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Write Handy Functions
function mkcd(){
	mkdir -p "$@" &&cd "$_"
}
function lsf(){
	#TODO: Fix properties
	ls "$@" | grep "$@"
}

# USE ZSH Functions