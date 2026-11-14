# dotfiles

My macOS setup, kept in Git so a new Mac can be restored with one command and
changes made on one machine can be carried to another.

The repository lives at `~/.dotfiles`. Configuration files in the home
directory are symlinks into it, so editing either path edits the same file.

## What it manages

| Area                | Source                                               |
| ------------------- | ---------------------------------------------------- |
| Shell               | `zshrc`, `zshenv`, `zprofile`, `bashrc`              |
| Git and GitHub CLI  | `gitconfig`, `config/git`, `config/gh`               |
| Terminal and prompt | `config/ghostty`, `config/starship.toml`, `config/bat` |
| Apps and packages   | `Brewfile` (Homebrew formulae, casks, App Store apps) |
| Node                | `node-version`, `config/node`                        |
| Coding agents       | `config/claude`, `config/codex`, `config/t3`         |
| Agent skills        | `config/skills`, `skills/`                           |

`install.conf.yaml` and `config/files.json` list every linked file.

## Set up a new Mac

1. Sign in to the App Store. `Brewfile` installs App Store apps, including Xcode.
2. Install the Command Line Tools, which provide Git:

    ```zsh
    xcode-select --install
    ```

3. Clone over HTTPS. Switch to SSH once everything is installed.

    ```zsh
    git clone https://github.com/OllieJT/dotfiles-macos.git ~/.dotfiles
    cd ~/.dotfiles
    ```

4. Review [Brewfile](Brewfile) and delete anything this Mac should not get.
5. Run the installer. It asks for your password several times.

    ```zsh
    ./install
    ```

6. Restart the computer.
7. Complete the [manual steps](#manual-steps).

### What `./install` does

It is safe to run again; finished steps are skipped or repeated harmlessly.

1. Links the shell, Git, and tool configuration into the home directory
   ([install.conf.yaml](install.conf.yaml)). A file already at a link's
   location is replaced.
2. Installs Homebrew, then everything in [Brewfile](Brewfile).
3. Makes Homebrew's zsh the default shell.
4. Creates `~/Developer` and `~/Scripts`.
5. Accepts the Xcode licence.
6. Installs Node LTS with fnm and the global npm tools.
7. Links agent and app settings ([config/files.json](config/files.json)).
   Replaced originals are kept in `~/.local/state/dotfiles/backups`.
8. Restores agent skills and clones my personal skills into
   `~/Developer/skills`.

### Manual steps

- Sign in to GitHub: `gh auth login`.
- Sign in to the coding agents, then run `npm run config:install` again so T3
  model selections apply.
- Install Spotify and [Postgres.app](https://postgresapp.com/).
- Disable the Spotlight keyboard shortcut; it conflicts with Raycast.
- Set app shortcuts:

    | App       | Menu item        | Shortcut             |
    | --------- | ---------------- | -------------------- |
    | Figma.app | Copy Properties  | Command + Option + C |
    | Figma.app | Paste Properties | Command + Option + P |

- Switch the repository to SSH:

    ```zsh
    # Generate a key
    ssh-keygen -t ed25519 -C "<YOUR_EMAIL>@users.noreply.github.com"

    # Start the ssh-agent
    eval "$(ssh-agent -s)"

    # Load the key automatically and keep its passphrase in the keychain
    << EOF > ~/.ssh/config
    Host github.com
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
    EOF

    ssh-add --apple-use-keychain ~/.ssh/id_ed25519

    # Copy the public key, then add it at github.com > Settings > SSH and GPG keys
    pbcopy < ~/.ssh/id_ed25519.pub

    # Test the connection
    ssh -T git@github.com

    git -C ~/.dotfiles remote set-url origin git@github.com:OllieJT/dotfiles-macos.git
    ```

## Day to day

[README-UPDATE.md](README-UPDATE.md) covers updating the Brewfile, settings,
and skills.

Coding agents manage this repository through the `dotfiles` skill
([skills/dotfiles/SKILL.md](skills/dotfiles/SKILL.md)): adding and removing
files, saving to GitHub, and updating from it.

## Shell additions

| Command | Description                                         |
| ------- | --------------------------------------------------- |
| `ls`    | `eza` with a header, file types, and Git status     |
| `bat`   | `cat` with syntax highlighting                      |
| `mkcd`  | Makes a directory and moves into it                 |
| `lsf`   | Lists files matching a pattern: `lsf ~/Downloads .pdf` |
| `trail` | Prints each `PATH` entry on its own line            |
| `bbd`   | Regenerates the Brewfile from installed software    |

## TODO

- [ ] Move these to GitHub issues
- [ ] Resolve slow switching shells (`.zshenv` ifs)
- [ ] Configure the macOS Dock with [dockutil](https://github.com/kcrawford/dockutil)
- [ ] Document the Raycast configuration
