#!/usr/bin/env zsh

echo "\n  [System Preferences]: 🚧 STARTING\n"

# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

echo "\n  [System Preferences]: 🔐 Pasword required -> changes to system preferences"
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# defaults read NSGlobalDomain > defaults.NSGlobalDomain.log
# defaults read com.google.Chrome > app.chrome.log
# defaults read com.apple.dock > system.dock.log

echo "\n  [System Preferences]: 🚧 Configuring System...\n"
zsh ~.dotfiles/setup/util/macos-preferences/system.zsh

echo "\n  [System Preferences]: 🚧 Configuring Apps...\n"
zsh ~.dotfiles/setup/util/macos-preferences/app.zsh


###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Mail" \
	"Raycast" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null
done

echo "\n  [System Preferences]: ✅ COMPLETE\n"
echo "\n  [System Preferences]: ⁉️ Note that some of these changes require a logout/restart to take effect.\n"