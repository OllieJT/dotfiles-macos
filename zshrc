echo "Loaded .zshrc"

# Set Variables

# Change zshrc

# Create Aliases
alias ls="ls -lAFh"

# Customize PS1 Prompt(s)
PROMPT="
%1~ %L %#"

RPROMPT="%*"

# Add locations to $PATH variable

# Write Handy Functions
function mkcd(){
	mkdir -p "$@" &&cd "$_"
}
function lsf(){
	#TODO: Fix properties
	ls "$@" | grep "$@"
}

# USE ZSH Functions