#!/usr/bin/env zsh

echo "\n  [Dev - X-Code Setup]: 🚧 STARTING\n"

# Should we wrap this in a conditional?
echo "\n  [Dev - X-Code Setup]: 🔐 Pasword required -> accept Xcode license"
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch

echo "\n  [Dev - X-Code Setup]: ✅ COMPLETE\n"
