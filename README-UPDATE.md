# dotfiles Update Instructions

### Brew

```sh

# (Optional) Upgrade all app versions
brew upgrade

# Update Brewfile
# Equivalent to: cd $DOTFILES && brew bundle dump --force --describe
bbd

# Install from brewfile
cd $DOTFILES
brew tap
brew bundle --verbose
```
