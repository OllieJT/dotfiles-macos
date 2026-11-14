#!/usr/bin/env zsh
set -e

dotfiles_root="${0:A:h:h}"
eval "$(fnm env --shell zsh)"
fnm install --lts --use

# Preserve the existing SVG optimizer behavior and provide Corepack on new Node releases.
npm install --global svgo@3.3.2 corepack@0.34.5

# Existing global development tools.
npm install --global @sanity/cli
npm install --global vercel

cd "$dotfiles_root"
npm ci --ignore-scripts
npm run config:install
npm run skills:install
