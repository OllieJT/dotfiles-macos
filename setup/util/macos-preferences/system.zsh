#!/usr/bin/env zsh

zsh ~.dotfiles/setup/util/macos-preferences/system.dock.zsh
zsh ~.dotfiles/setup/util/macos-preferences/system.finder.zsh
zsh ~.dotfiles/setup/util/macos-preferences/system.input.zsh
zsh ~.dotfiles/setup/util/macos-preferences/system.interface.zsh
zsh ~.dotfiles/setup/util/macos-preferences/system.screen.zsh

###############################################################################
# Energy saving                                                               #
###############################################################################

# Enable lid wakeup
sudo pmset -a lidwake 1

# Restart automatically on power loss
sudo pmset -a autorestart 1

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Sleep the display after 15 minutes
sudo pmset -a displaysleep 15

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Enable the debug menu in iCal (pre-10.8)
defaults write com.apple.iCal IncludeDebugMenu -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# Auto-play videos when opened with QuickTime Player
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 1;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}'
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Sidecar                                                                     #
###############################################################################

defaults write com.apple.sidecar.display showTouchbar -bool false
defaults write com.apple.sidecar.display sidebarShown -bool false

###############################################################################
# Control center                                                              #
###############################################################################

defaults write com.apple.controlcenter "NSStatusItem Preferred Position BentoBox" -int 127;
defaults write com.apple.controlcenter "NSStatusItem Preferred Position FocusModes" -int 158;
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Shortcuts" -int 453;
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Sound" -int 159;
defaults write com.apple.controlcenter "NSStatusItem Visible BentoBox" -bool true;
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Clock" -bool true;
defaults write com.apple.controlcenter "NSStatusItem Visible DoNotDisturb" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Item-0" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Item-1" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Item-2" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Item-3" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Item-4" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Shortcuts" -bool false;
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true;
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false;

###############################################################################
# Misc                                                                     #
###############################################################################

# Sharing Discoverability
defaults write com.apple.sharingd DiscoverableMode -string "Contacts Only"

# AddressBook Birthdays
defaults write com.apple.AddressBook ABBirthDayVisible -bool true



defaults write NSGlobalDomain NSPreferredWebServices -dict NSWebServicesProviderWebSearch '{
	NSDefaultDisplayName = DuckDuckGo;
	NSProviderIdentifier = "com.duckduckgo";
}'