#!/usr/bin/env zsh

echo "\n  [Node Setup]: 🚧 STARTING\n"

if exists nvm; then
	echo "\n  [Node Setup]: 🟢 Skipping NVM Install -> Already Installed [$NVM_BIN]\n"
else
	echo "\n  [Node Setup]: 🚧 Cloning lukechilds/zsh-nvm\n"
	git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
fi



echo "\n  [Node Setup]: 🚧 Installing Latest Node LTS version\n"
nvm use
nvm install
corepack disable



echo "\n  [Node Setup]: 🚧 Installing Global Packages\n"
npm install --global @sanity/cli
npm install --global browser-sync
npm install --global netlify-cli
npm install --global supabase
npm install --global vercel
npm install --global typescript

echo "\n  [Node Setup]: 🟢 Global packages installed\n"
npm list --global --depth=0

mkdir ~/Developer -p

echo "\n  [Node Setup]: ✅ COMPLETE\n"

$(yarn global bin)