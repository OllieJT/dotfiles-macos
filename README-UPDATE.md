# dotfiles Update Instructions

### Brew

```sh

# (Optional) Upgrade all app versions
brew upgrade

# Update Brewfile
# Discover installed software and apply the App Store blacklist
bbd

# Install from brewfile
cd $DOTFILES
brew tap
brew bundle --verbose
```

`bbd` runs `node ~/.dotfiles/scripts/update-brewfile.mjs`. It includes installed
App Store apps by default, then excludes only the IDs in
`config/homebrew/mas-blacklist.txt`. Add one ID per line; comments start with `#`.
Use `mas list` to find an app's ID. Apps absent from the blacklist continue to be
discovered automatically, including newly installed apps.

The blacklist only controls the generated Brewfile. It does not uninstall apps
or stop their App Store updates. Run `bbd` after editing it; a direct
`brew bundle dump` bypasses the blacklist.
