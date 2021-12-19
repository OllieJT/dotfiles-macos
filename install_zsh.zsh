#!/usr/bin/env zsh

echo "\n [ZSH Setup]: 🚧 STARTING\n"



if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
	echo "\n [ZSH Setup]: 🟢 [/opt/homebrew/bin/zsh] already exists in [/etc/shells]\n"
else
	echo "\n [ZSH Setup]: 🔐 Pasword required for SUDO user -> Adding ZSH to [/etc/shells]"
	echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi



if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
	echo "\n [ZSH Setup]: 🟢 [$SHELL] is already [/opt/homebrew/bin/zsh]\n"
else
	echo "\n [ZSH Setup]: 🔐 Pasword required for current user -> Changhing default shell to ZSH"
	chsh -s '/opt/homebrew/bin/zsh'
fi


if sh --version | grep -q zsh; then
	echo "\n [ZSH Setup]: 🟢 [/private/var/select/sh] already linked to [/bin/zsh]\n"
  echo '/private/var/select/sh already linked to /bin/zsh'
else
	echo "\n [ZSH Setup]: 🔐 Pasword required for SUDO user -> Symlinking sh to zsh"
  echo "Enter superuser (sudo) password to symlink sh to zsh"
  # Looked cute, might delete later, idk
  sudo ln -sfv /bin/zsh /private/var/select/sh

  # I'd like for this to work instead.
  # sudo ln -sfv /opt/homebrew/bin/zsh /private/var/select/sh
fi



echo "\n [ZSH Setup]: ✅ COMPLETE\n"