# .zshrc - Runs only for interactive shells (terminals you type in)
echo "Loaded .zshrc"


# ─────────────────────────────────────────────────────────────
# Environment Variables
# ─────────────────────────────────────────────────────────────

# bat - a better `cat` with syntax highlighting
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # Use bat for man pages
export NULLCMD=bat  # Empty redirects (e.g., `> file`) use bat instead of cat

# Dotfiles location for scripts/configs
export DOTFILES="$HOME/.dotfiles"
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"

# SVG optimizer CLI path
export SVGO_BIN="$HOME/.local/bin/svgo"

# VS Code as default editor (-w waits for file to close)
export EDITOR="code -w"

# Tells npm you're using pnpm (some tools check this)
export npm_config_user_agent="pnpm/v9.2.0"

export TURBO_NO_UPDATE_NOTIFIER=true



# ─────────────────────────────────────────────────────────────
# Python
# ─────────────────────────────────────────────────────────────

export PYTHON_INSTALL="/Library/Frameworks/Python.framework/Versions/3.11/bin"
export PATH="$PYTHON_INSTALL:$PATH"
alias python="python3"
alias pip="python -m pip"


# ─────────────────────────────────────────────────────────────
# Shell Behavior
# ─────────────────────────────────────────────────────────────

# Tab completion system
autoload -Uz compinit && compinit

# History settings
[[ -z $HISTFILE ]] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000                    # Max commands in memory
SAVEHIST=4000                    # Max commands saved to file
setopt histNoStore               # Don't store `history` command itself
setopt extendedHistory           # Save timestamps with commands
setopt histIgnoreAllDups         # Remove older duplicate entries
unsetopt appendHistory           # (default off anyway)
setopt incAppendHistoryTime      # Write to history file immediately

# Navigation conveniences
setopt autoCd      # Type directory name to cd into it (no `cd` needed)
setopt globDots    # Include dotfiles in tab completion


# ─────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────

alias ls="eza -la --classify=always --header --git"       # Better ls with git status
alias bbd='node "$HOME/.dotfiles/scripts/update-brewfile.mjs"'
alias pnpmup='echo "pnpm up -i --latest" && pnpm up -i --latest'
alias fix_tower_ai='brew reinstall --cask --binaries codex && rehash && codex --version'
alias trail="bat <<<${(F)path}"  # Pretty print $PATH, one entry per line

# Custom scripts
alias jsinit="~/Scripts/jsinit.sh"
alias cpgit="~/Scripts/cpgit.sh"
alias scrapi="~/Scripts/scrapi.sh"

alias shadcn="pnpm dlx shadcn"


# ─────────────────────────────────────────────────────────────
# PATH Additions
# ─────────────────────────────────────────────────────────────

typeset -U path  # Deduplicate PATH entries
path=(
	$path
	"/opt/homebrew/bin"
	"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)


# ─────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────

# Create directory and cd into it
function mkcd() {
	mkdir -p "$@" && cd "$_"
}

# List files matching a pattern: `lsf ~/Downloads .pdf`
function lsf() {
	ls "$1" | grep "$2"
}

# Kill process using a port: `kill_by_port 3000`
function kill_by_port() {
	lsof -i ":${1}" | awk 'NR > 1 {print $2}' | xargs kill -9
}

# Kill all running Docker containers
function kill_docker() {
	docker kill $(docker ps -q)
}

# Add spacer tile to Dock
function dock_add_space() {
	defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
	killall Dock
}


# ─────────────────────────────────────────────────────────────
# Prompt & Integrations
# ─────────────────────────────────────────────────────────────

# Starship - cross-shell prompt (configured in ~/.config/starship.toml)
eval "$(starship init zsh)"

# iTerm2 shell integration (tab titles, marks, etc.)
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# ─────────────────────────────────────────────────────────────
# Package Managers & Version Managers
# ─────────────────────────────────────────────────────────────

# pnpm - fast npm alternative
export PNPM_HOME="/Users/olliejt/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun - fast JS runtime & package manager
[ -s "/Users/olliejt/.bun/_bun" ] && source "/Users/olliejt/.bun/_bun"  # completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm - fast Node version manager
eval "$(fnm env --use-on-cd --shell zsh)"  # Setup fnm + auto-switch Node per .node-version
fnm use --install-if-missing  # Install missing version on terminal open



# ─────────────────────────────────────────────────────────────
# Claude Code
# ─────────────────────────────────────────────────────────────
# Claude Code sandbox with persistent auth
alias claude-sandbox='docker sandbox run --template docker/sandbox-templates:claude-code -v ~/.claude:/root/.claude claude'
alias ccs='claude-sandbox'
alias ccyolo='claude --dangerously-skip-permissions'

# ─────────────────────────────────────────────────────────────
# Final PATH
# ─────────────────────────────────────────────────────────────

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


alias wavemic='/Users/olliejt/Documents/Codex/2026-11-10/whenever-i-connect-my-bluetooth-headphones/outputs/set-wave-xlr-input.swift'


# Added by Antigravity CLI installer
export PATH="/Users/olliejt/.local/bin:$PATH"
