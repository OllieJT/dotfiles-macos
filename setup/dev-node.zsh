#!/usr/bin/env zsh

echo "\n  [Dev - Node Install]: 🚧 STARTING\n"

if exists nvm; then
	echo "\n  [Dev - Node Install]: 🟢 Skipping NVM Install -> Already Installed [$NVM_BIN]\n"
else
	echo "\n  [Dev - Node Install]: 🚧 Cloning lukechilds/zsh-nvm\n"
	git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
fi



echo "\n  [Dev - Node Install]: 🚧 Installing Latest Node LTS version\n"
nvm use
nvm install
corepack disable



echo "\n  [Dev - Node Install]: 🚧 Installing Global Packages\n"
npm install --global @sanity/cli
npm install --global netlify-cli
npm install --global vercel

echo "\n  [Dev - Node Install]: 🟢 Global packages installed\n"
npm list --global --depth=0

echo "\n  [Dev - Node Install]: ✅ COMPLETE\n"
