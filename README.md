# dotfiles

## TODO

-   Setup MacOS preferences
    -   Disable spotlight command (conflicts with Raycast)
    -   Configure dock https://github.com/kcrawford/dockutil
-   Add manual instructions for Raycast Config
-   Add Node & NVM
    -   Install Yarn
    -   Install NPM CLI tools
        -   @sanity/cli
    -   Set nvm defaults
-   Install Github desktop
-   Create Developer folder
-   Install iTerm
-   Add Dracula theme throughout
-   Add Inter font
-   Resolve shell extensions or switch back to fish

## Restore Instructions

1. `xcode-select --install` (Command Line Tools are required for Git and Homebrew)
2. `git clone https://github.com/olliejt/dotfiles-macos.git ~/.dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
3. `cd ~/.dotfiles`
4. Do one last Software Audit by editing [Brewfile](Brewfile) directly.
5. [`./install`](install)
6. Restart computer.
7. Run `mackup restore`. Consider doing a `mackup restore --dry-run --verbose` first.
8. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to GitHub, and switch remotes.

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

#### Snappy App

1. `System Preferences > Keyboard > Shortcuts > Screenshots > Save picture of selected area as a file (cmd+shift+4)` uncheck.
2. `Snappy Preferences > General > Take snap` change from `cmd+shift+2` (which conflicts with ScreenFlow) to `cmd+shift+4`.

#### Alfred

1. `System Preferences > Keyboard > Shortcuts > Spotlight > Show Spotlight search (cmd+space)` uncheck.
2. `Alfred Preferences > Powerpack` add License.
3. `Alfred Preferences > General > Request Permissions`.
4. `Alfred Preferences > General > Alfred Hotkey` change to `cmd+space`.
5. `Alfred Preferences > Advanced > Set preferences folder` and set to `~/Dropbox/dotfiles/Alfred`.
