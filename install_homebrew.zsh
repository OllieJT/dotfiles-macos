#!/usr/bin/env zsh

echo "\n  [Homebrew Setup]: 🚧 STARTING\n"

if exists brew; then
	echo "\n  [Homebrew Setup]: 🟢 Skipping Install -> Already Installed\n"
else
	echo "\n  [Homebrew Setup]: 🟡 Installing\n"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --verbose

 echo "\n  [Homebrew Setup]: ✅ COMPLETE\n"