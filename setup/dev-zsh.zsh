#!/usr/bin/env zsh

echo "\n [dev - ZSH]: 🚧 STARTING\n"
echo "\n [dev - ZSH Install]: 🚧 STARTING\n"

# Installs ZSH from homebrew
if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
	echo "\n  [dev - ZSH Install]: 🟢 Skipping Install -> [/opt/homebrew/bin/zsh] already exists in [/etc/shells]\n"
else
	echo "\n  [dev - ZSH Install]: 🔐 Pasword required for SUDO user -> Adding ZSH to [/etc/shells]"
	echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi

echo "\n  [dev - ZSH Install]: ✅ COMPLETE\n"
echo "\n [dev - ZSH Setup]: 🚧 STARTING\n"

# Changes default shell to ZSH
if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
	echo "\n  [dev - ZSH Setup]: 🟢 [$SHELL] is already [/opt/homebrew/bin/zsh]\n"
else
	echo "\n  [dev - ZSH Setup]: 🔐 Pasword required for current user -> Changhing default shell to ZSH"
	chsh -s '/opt/homebrew/bin/zsh'
fi

# Linking default sh command to zsh
if sh --version | grep -q zsh; then
	echo "\n  [dev - ZSH Setup]: 🟢 [/private/var/select/sh] already linked to [/bin/zsh]\n"
else
	echo "\n  [dev - ZSH Setup]: 🔐 Pasword required for SUDO user -> Symlinking sh to zsh"
  # Looked cute, might delete later, idk
  sudo ln -sfv /bin/zsh /private/var/select/sh

  # I'd like for this to work instead.
  # sudo ln -sfv /opt/homebrew/bin/zsh /private/var/select/sh
fi


echo "\n  [dev - ZSH Setup]: ✅ COMPLETE\n"
echo "\n  [dev - ZSH]: ✅ COMPLETE\n"
