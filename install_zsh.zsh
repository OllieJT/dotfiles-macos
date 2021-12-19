#!/usr/bin/env zsh

echo "\n [ZSH Setup]: 🚧 STARTING\n"



if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
	echo "\n  [ZSH Setup]: 🟢 Skipping Install -> [/opt/homebrew/bin/zsh] already exists in [/etc/shells]\n"
else
	echo "\n  [ZSH Setup]: 🔐 Pasword required for SUDO user -> Adding ZSH to [/etc/shells]"
	echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi



if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
	echo "\n  [ZSH Setup]: 🟢 [$SHELL] is already [/opt/homebrew/bin/zsh]\n"
else
	echo "\n  [ZSH Setup]: 🔐 Pasword required for current user -> Changhing default shell to ZSH"
	chsh -s '/opt/homebrew/bin/zsh'
fi


if sh --version | grep -q zsh; then
	echo "\n  [ZSH Setup]: 🟢 [/private/var/select/sh] already linked to [/bin/zsh]\n"
else
	echo "\n  [ZSH Setup]: 🔐 Pasword required for SUDO user -> Symlinking sh to zsh"
  # Looked cute, might delete later, idk
  sudo ln -sfv /bin/zsh /private/var/select/sh

  # I'd like for this to work instead.
  # sudo ln -sfv /opt/homebrew/bin/zsh /private/var/select/sh
fi


# TODO: Confirm this fix pre-install check
if [ "$ZSH_CUSTOM" = "$HOME/.oh-my-zsh" ]; then
	echo "\n  [ZSH Setup]: 🟢 OhMyZSH already installed\n"
else
	echo "\n  [ZSH Setup]: 🚧 Installing OhMyZSH\n"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	# TODO: This assumes only new setups require the plugins
	echo "\n  [ZSH Setup]: 🚧 Installing omz plugin: Auto Suggestions\n"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	echo "\n  [ZSH Setup]: 🚧 Installing omz plugin: Auto Completions\n"
	git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

fi





echo "\n  [ZSH Setup]: ✅ COMPLETE\n"