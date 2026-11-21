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

`config/homebrew/required-casks.txt` lists apps that should stay in Brewfile even
when the installed app is not managed by Homebrew. `bbd` adds missing entries
after dumping, while retaining any existing cask options. Ghostty is included
here because it is already installed outside Homebrew.

### Settings and skills

Run these from the dotfiles checkout:

```sh
npm ci --ignore-scripts
npm run config:install
npm run skills:install
```

The existing `./install` flow runs these through `setup/dev-node.zsh`, using fnm
to install Node LTS first. `npm test` checks the project-owned configuration
merges, backup/link policy, and skill restoration planning.

`config/files.json` lists the individual files we manage. Plain settings link
directly to tracked files. Mixed settings link to generated files under
`~/.local/state/dotfiles/generated`, assembled from tracked preferences and
private fields retained locally. Original files are backed up under
`~/.local/state/dotfiles/backups`; private overlays and generated files have
restricted permissions and stay outside Git.

Edit the tracked preferences, then run `npm run config:install` to apply them.
For mixed settings, edits made in an app do not automatically update the
tracked preferences. Reapplying keeps current private fields and applies the
tracked preferences again. Keep authentication tokens and device IDs local.
On a new device, T3 model selections wait until the app has assigned local
provider IDs; after account/provider setup, rerun `npm run config:install`.

Skills from skills.sh are recorded in `config/skills/skill-lock.json`, linked
at `~/.agents/.skill-lock.json`. The installer downloads missing skills and
recreates links for installed agents selected in that lock. Existing skills
are kept, and existing independent agent copies are reported and preserved.
An unavailable source is reported as an error after other skills are linked.
Restoring an old global lock without a commit/ref uses its current upstream
source; a folder hash alone does not pin a Git checkout.

Personal skill sources and a `blacklist` are configured in
`config/skills/personal.json`. The installer discovers every non-hidden,
top-level folder containing a `SKILL.md` file, except exact folder names in
the blacklist. New skills need no manifest entry: create their folder and
`SKILL.md`, then run `npm run skills:install` to link them. Existing linked
skills continue to reflect edits immediately; this is not a background watcher.

Adding a folder to the blacklist removes its personal skill symlinks on the
next install, while preserving its source and any unrelated files or links.
Names shared with the skills.sh lock must be resolved explicitly, so one source
does not overwrite the other.

The installer clones your repository when its checkout is missing, and
otherwise fetches and fast-forwards it. It skips the pull, with a warning, when
the checkout is detached, has no upstream, has diverged, or has local changes
the pull would overwrite; uncommitted changes are never discarded. Skills link
directly into that checkout through `~/.agents/skills`. The installer warns
about skills with uncommitted changes and about unpushed commits: those exist
only on this device until pushed. Set `directory` in the personal
manifest if you use a different checkout location.

Skills owned by this repository live in `skills/<name>/`. `install.conf.yaml`
links each one into `~/.agents/skills` and `~/.claude/skills`; apply with
`./install --only link`. `skills/dotfiles` teaches agents how to manage this
repository.

Preview skill restoration with:

```sh
npm run skills:install -- --dry-run
```

New skills installed with the skills.sh CLI update the linked global lock;
review that diff before committing. Plugin-managed skills remain managed by
their plugins, outside this manifest.
