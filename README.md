# dotfiles

## TODO

-   [ ] Move these to github issues
-   [ ] Resolve slow switching shells (.zshenv if's)
-   [ ] Configure MacOS dock https://github.com/kcrawford/dockutil
-   [ ] Login to `gh`: [gh-auth](https://cli.github.com/manual/gh_auth_login)

## Restore Instructions

1. `xcode-select --install` (Command Line Tools are required for Git and Homebrew)
2. `git clone https://github.com/olliejt/dotfiles-macos.git ~/.dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
3. `cd ~/.dotfiles`
4. Do one last Software Audit by editing [Brewfile](Brewfile) directly.
5. [`./install`](install)
6. Restart computer.
7. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to GitHub, and switch remotes.

    ```zsh
    # Generate SSH key in default location (~/.ssh/config)
    ssh-keygen -t rsa -b 4096 -C "66495007+eieioxyz@users.noreply.github.com"

    # Start the ssh-agent
    eval "$(ssh-agent -s)"

    # Create config file with necessary settings
    << EOF > ~/.ssh/config
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_rsa
    EOF

    # Add private key to ssh-agent
    ssh-add -K ~/.ssh/id_rsa

    # Copy public key and add to github.com > Settings > SSH and GPG keys
    pbcopy < ~/.ssh/id_rsa.pub

    # Test SSH connection, then verify fingerprint and username
    # https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
    ssh -T git@github.com

    # Switch from HTTPS to SSH
    git remote set-url origin git@github.com:eieioxyz/dotfiles_macos.git
    ```

### Manual Steps

-   [ ] Install Apps
    -   Spotify
    -   [Postgress App](https://postgresapp.com/)

Accept Xcode terms

```
sudo xcodebuild -license
```

## Update Instructions

### Brew

```sh
# Update Brewfile
# Equivilent to: cd $DOTFILES && brew bundle dump --force --describe
bbd

# Install from brewfile
cd $DOTFILES
brew tap
brew bundle --verbose
```

## Cool new commands

| Command | Description                                                               |
| ------- | ------------------------------------------------------------------------- |
| ls      | Upgraded with lsf and color highlighting for a cleaner output             |
| bat     | Can replace cat for showing the content of files with syntax highlighting |
| mkcd    | Makes a directory and moves to it                                         |
| trail   | Prints out shell paths with bat                                           |

## To be documented...

-   [ ] Disable spotlight command (conflicts with Raycast)
-   [ ] Enable iterm configuration
-   [ ] Raycast Config
