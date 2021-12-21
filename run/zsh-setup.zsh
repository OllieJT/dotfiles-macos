#!/usr/bin/env zsh

echo "\n [ZSH Setup]: 🚧 STARTING\n"



# Changes default shell to ZSH
if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
	echo "\n  [ZSH Setup]: 🟢 [$SHELL] is already [/opt/homebrew/bin/zsh]\n"
else
	echo "\n  [ZSH Setup]: 🔐 Pasword required for current user -> Changhing default shell to ZSH"
	chsh -s '/opt/homebrew/bin/zsh'
fi

# Linking default sh command to zsh
if sh --version | grep -q zsh; then
	echo "\n  [ZSH Setup]: 🟢 [/private/var/select/sh] already linked to [/bin/zsh]\n"
else
	echo "\n  [ZSH Setup]: 🔐 Pasword required for SUDO user -> Symlinking sh to zsh"
  # Looked cute, might delete later, idk
  sudo ln -sfv /bin/zsh /private/var/select/sh

  # I'd like for this to work instead.
  # sudo ln -sfv /opt/homebrew/bin/zsh /private/var/select/sh
fi


echo "\n  [ZSH Setup]: ✅ COMPLETE\n"
