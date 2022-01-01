#!/usr/bin/env zsh

###############################################################################
# Contrast.app                                                                #
###############################################################################

# Shortcut: Pick Background ⌃ ⌘ ⇩
defaults write com.nothingmagical.contrast BackgroundKeyCombo -dict keyCode 125 modifiers 4352

# Shortcut: Pick Foreground ⌃ ⌘ ⇧
defaults write com.nothingmagical.contrast ForegroundKeyCombo -dict keyCode 126 modifiers 4352

# Shortcut: Show/Hide ⌃ ⌘ →
defaults write com.nothingmagical.contrast ShowKeyCombo -dict keyCode 124 modifiers 4352

# Preferences
defaults write com.nothingmagical.contrast ColorProfile -string "sRGB"
defaults write com.nothingmagical.contrast LaunchAtLogin -bool true
defaults write com.nothingmagical.contrast LowercaseHex -bool false
defaults write com.nothingmagical.contrast TutorialCompleted -bool true