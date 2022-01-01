#!/usr/bin/env zsh

zsh ~.dotfiles/setup/util/macos-preferences/app.chrome.zsh
zsh ~.dotfiles/setup/util/macos-preferences/app.contrast.zsh
zsh ~.dotfiles/setup/util/macos-preferences/app.messages.zsh
zsh ~.dotfiles/setup/util/macos-preferences/app.raycast.zsh
zsh ~.dotfiles/setup/util/macos-preferences/app.safari.zsh
zsh ~.dotfiles/setup/util/macos-preferences/app.terminal.zsh
zsh ~.dotfiles/setup/util/macos-preferences/app.transmission.zsh

###############################################################################
# Tweetbot.app                                                                #
###############################################################################

# Bypass the annoyingly slow t.co URL shortener
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true


###############################################################################
# Things.app                                                                  #
###############################################################################

# Bypass Onboarding
defaults write com.culturedcode.ThingsMac OnboardingDidComplete -bool true


###############################################################################
# Github Desktop.app                                                          #
###############################################################################

# Set initial directory to `~/.dotfiles`
defaults write com.github.GitHubClient NSNavLastRootDirectory -string "~/.dotfiles"

###############################################################################
# Visual Studio Code.app                                                      #
###############################################################################

# Set initial directory to `~/.dotfiles`
defaults write com.microsoft.VSCode NSNavLastRootDirectory -string "~/.dotfiles"

###############################################################################
# Hand Mirror.app                                                      #
###############################################################################

# Set Preferences
defaults write net.rafaelconde.Hand-Mirror dismissPreference -bool true
defaults write net.rafaelconde.Hand-Mirror selectedPopoverSize -int 2