
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

# This file only loads in the interactive shell, that means configuration defined here won't be avalible in other scripts.
echo "Loaded .zshrc"

# Set Variables
## Bat syntax highlighting for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat
export DOTFILES="$HOME/.dotfiles"
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$DOTFILES/oh-my-zsh"

# Change ZSH Options
## OhMyZSH
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
## Uncomment one of the following lines to change the auto-update behavior
## zstyle ':omz:update' mode disabled  # disable automatic updates
## zstyle ':omz:update' mode auto      # update automatically without asking
## zstyle ':omz:update' mode reminder  # just remind me to update when it's time
plugins=(
	brew
	dotenv
	gh
	git
	macos
	#npm
	#npx
	#nvm
	safe-paste
	zsh-autosuggestions
	zsh-completions
)
source $ZSH/oh-my-zsh.sh

# Add "zstyles" for Completions & Other Things
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':plugin:history-search-multi-word' clear-on-cancel 'yes'

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

# Enable ZSH Plugins
#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
