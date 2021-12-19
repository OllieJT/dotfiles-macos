#!/usr/bin/env zsh

echo "\n  [Homebrew Setup]: 🚧 STARTING\n"

if exists brew; then
	echo "\n  [Homebrew Setup]: 🟢 Skipping Install -> Already Installed\n"
else
	echo "\n  [Homebrew Setup]: 🟡 Installing\n"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --verbose

# Should we wrap this in a conditional?
echo "\n  [Homebrew Setup]: 🔐 Pasword required -> accept Xcode license"
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch

# This works to solve the Insecure Directories issue:
# compaudit | xargs chmod go-w
# But this is from the Homebrew site, though `-R` was needed:
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
chmod -R go-w "$(brew --prefix)/share"


 echo "\n  [Homebrew Setup]: ✅ COMPLETE\n"