#!/usr/bin/env zsh

echo "\n [ZSH Install]: 🚧 STARTING\n"


# Installs ZSH from homebrew
if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
	echo "\n  [ZSH Install]: 🟢 Skipping Install -> [/opt/homebrew/bin/zsh] already exists in [/etc/shells]\n"
else
	echo "\n  [ZSH Install]: 🔐 Pasword required for SUDO user -> Adding ZSH to [/etc/shells]"
	echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi







# TODO: Confirm this fix pre-install check
if [ "$ZSH_CUSTOM" = "$HOME/.oh-my-zsh" ]; then
	echo "\n  [ZSH Install]: 🗑 Deleting previous OhMyZSH installation: [$HOME/.oh-my-zsh]\n"
	sudo rm -rf "$HOME/.oh-my-zsh"
	echo "\n  [ZSH Install]: 🟢 Ready for fresh OhMyZSH installation\n"
else
	echo "\n  [ZSH Install]: 🟢 Ready for fresh OhMyZSH installation\n"

fi






echo "\n  [ZSH Install]: 🚧 Installing OhMyZSH\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "\n  [ZSH Install]: 🚧 Installing OhMyZSH plugin: Auto Suggestions\n"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "\n  [ZSH Install]: 🚧 Installing OhMyZSH plugin: Auto Completions\n"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions






echo "\n  [ZSH Install]: ✅ COMPLETE\n"