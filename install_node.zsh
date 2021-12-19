#!/usr/bin/env zsh

echo "\n  [Node Setup]: 🚧 STARTING\n"

echo "\n  [Node Setup]: 🚧 Cloning lukechilds/zsh-nvm\n"
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm

echo "\n  [Node Setup]: 🚧 Installing Latest Node LTS version\n"
nvm use
nvm install

echo "\n  [Node Setup]: ✅ COMPLETE\n"