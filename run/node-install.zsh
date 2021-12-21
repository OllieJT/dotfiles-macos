#!/usr/bin/env zsh

echo "\n  [Node Install]: 🚧 STARTING\n"

if exists nvm; then
	echo "\n  [Node Install]: 🟢 Skipping NVM Install -> Already Installed [$NVM_BIN]\n"
else
	echo "\n  [Node Install]: 🚧 Cloning lukechilds/zsh-nvm\n"
	git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
fi



echo "\n  [Node Install]: 🚧 Installing Latest Node LTS version\n"
nvm use
nvm install
corepack disable



echo "\n  [Node Install]: 🚧 Installing Global Packages\n"
npm install --global @sanity/cli
npm install --global browser-sync
npm install --global netlify-cli
npm install --global supabase
npm install --global vercel
npm install --global typescript

echo "\n  [Node Install]: 🟢 Global packages installed\n"
npm list --global --depth=0

mkdir ~/Developer -p

echo "\n  [Node Install]: ✅ COMPLETE\n"