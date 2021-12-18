echo "Loaded .zshrc"

# Set Variables
## Bat syntax highlighting for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"


# Change zshrc

# Create Aliases
alias ls="ls -lAFh"

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