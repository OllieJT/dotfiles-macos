# This file only loads in the interactive shell, that means configuration defined here won't be avalible in other scripts.
echo "Loaded .zshrc"

# Set Variables
## Bat syntax highlighting for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat

# Change zshrc

# Create Aliases
# alias ls="ls -lAFh"
alias ls="exa -laFh --git"
alias bbd="cd ~/.dotfiles && brew bundle dump --force --describe && echo 'Brewfile updated ✅'"
alias trail="bat <<<${(F)path}"

# Customize PS1 Prompt(s)
PROMPT="
%1~ %L %#"

RPROMPT="%*"

# Add locations to $PATH variable
## Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/opt/homebrew/bin"



# Write Handy Functions
function mkcd(){
	mkdir -p "$@" &&cd "$_"
}
function lsf(){
	ls "$1" | grep "$2"
}


# USE ZSH Functions
add-zsh-hook chpwd load-nvmrc
load-nvmrc