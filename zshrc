# This file only loads in the interactive shell, that means configuration defined here won't be avalible in other scripts.
echo "Loaded .zshrc"
nvm use


# Set Variables
## Bat syntax highlighting for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat
export DOTFILES="$HOME/.dotfiles"
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
# export ZSH="$HOME/.oh-my-zsh"
# export ZSH_CUSTOM="$DOTFILES/oh-my-zsh"

export DENO_INSTALL="/Users/olliejt/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"


# Load "New" Completion System
autoload -Uz compinit && compinit
## Adjust History Variables & Options
[[ -z $HISTFILE ]] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000 # Session Memory Limit
SAVEHIST=4000 # File Memory Limit
setopt histNoStore
setopt extendedHistory
setopt histIgnoreAllDups
unsetopt appendHistory # explicit and unnecessary
setopt incAppendHistoryTime


## Line Editor Options (Completion, Menu, Directory, etc.)
## autoMenu & autoList are on by default
setopt autoCd
setopt globDots


# Create Aliases
# alias ls="ls -lAFh"
alias ls="exa -laFh --git"
alias bbd="cd ~/.dotfiles && brew bundle dump --force --describe && echo 'Brewfile updated ✅'"
alias trail="bat <<<${(F)path}"

# Customize PS1 Prompt(s)
# PROMPT="%1~ %L %#"


# Add Locations to $path Array
typeset -U path
path=(
	$NVM_BIN,
	$path,
	"/opt/homebrew/bin"
	"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)




# Write Handy Functions
function mkcd(){
	mkdir -p "$@" &&cd "$_"
}
function lsf(){
	ls "$1" | grep "$2"
}

function kill_by_port(){
  lsof -i ":${1}" | awk 'NR > 1 {print $2}' | xargs kill -9
}

function dock_add_space(){
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock
}

# Enable ZSH Plugins

# end
eval "$(starship init zsh)"

export NODE_PATH=$NODE_PATH:`npm root -g`

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash