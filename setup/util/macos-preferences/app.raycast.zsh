#!/usr/bin/env zsh

###############################################################################
# Raycast.app                                                                #
###############################################################################

# Create Script Defaults
defaults write com.raycast.macos "create-script-command-author" -string "Ollie Taylor"
defaults write com.raycast.macos "create-script-command-mode" -string "Full Output"
defaults write com.raycast.macos "create-script-command-authorURL" -string "https://github.com/OllieJT"

# Preferences
defaults write com.raycast.macos NSNavLastRootDirectory -string "~/.dotfiles/Raycast"
defaults write com.raycast.macos raycastPreferredTheme -string "raycast-dark"
defaults write com.raycast.macos initialSpotlightHotkey -string "Command-49"
defaults write com.raycast.macos raycastGlobalHotkey -string "Command-49"
defaults write com.raycast.macos raycastUI_preferredTextSize -string "large"
defaults write com.raycast.macos store_everInstalled -array "9349c6b9-c442-4895-98e3-b3a926e74ed7" "c5ce763c-8582-4da2-badb-10b63d514297" "cd1bf1c8-96f3-4490-bf00-2530bb47306b" "6a85fdb8-09a0-4899-a720-622d6efaba15" "6fee61b7-d373-468a-b4cc-69728d0a23e6" "b965da17-f7de-4af3-81a9-e2280316dbe3" "80b2f7bf-85ba-4946-8b87-c0f015284bf5" "ba9ecf89-7162-4f6a-a417-5087d8d48a98" "0ceb0ec5-feb7-41fe-876c-c6c9c72940dc" "9bf95375-0729-4ce3-9fdc-dd8556453c0b" "1e915fb4-4a40-4555-8fad-99319ca35f19" "e00a9804-c047-414a-bf61-4d6701429328" "95e41a2e-a943-4d49-b0df-152c3db2f7e0"
defaults write com.raycast.macos boostRankingByPreviousSearches -bool true
