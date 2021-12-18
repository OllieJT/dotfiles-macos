#!/usr/bin/env zsh

echo "\n [Homebrew Setuip]: STARTING 🚧\n"

if exists brew; then
	echo "\n [Homebrew Setuip]: Skipping Install 🟢 (Already Installed)\n"
else
	echo "\n [Homebrew Setuip]: Installing 🟡\n"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --verbose

 echo "\n [Homebrew Setuip]: COMPLETE ✅\n"