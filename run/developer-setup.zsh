#!/usr/bin/env zsh

echo "\n  [Developer Setup]: 🚧 STARTING\n"

echo "\n  [Developer Setup]: 🟢 [$HOME/Developer] Created\n"
mkdir ~/Developer -p

# Should we wrap this in a conditional?
echo "\n  [Developer Setup]: 🔐 Pasword required -> accept Xcode license"
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch

echo "\n  [Developer Setup]: ✅ COMPLETE\n"
