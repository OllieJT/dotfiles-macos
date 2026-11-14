---
name: dotfiles
description: Manage the user's dotfiles repository at ~/.dotfiles. Use when the user mentions dotfiles, wants a config file in their home directory tracked, linked, untracked, or changed, wants Homebrew packages or agent skills recorded, or wants dotfiles saved to or updated from GitHub.
---

# Dotfiles

`~/.dotfiles` (GitHub `OllieJT/dotfiles-macos`, branch `main`) is the source of truth for this Mac's configuration. Each **managed file** has a **source** tracked in the repo and a **target** in `~` that is a symlink to it. Run every command below from `~/.dotfiles`; its `AGENTS.md` applies to any change you make there.

## Linkers

Three linkers create the symlinks. Pick by target:

| Linker           | Manifest                    | Use for                                                                                              | Apply                     |
| ---------------- | --------------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------- |
| dotbot           | `install.conf.yaml` `link:` | Whole files or directories the repo fully owns: shell, git, CLI tool config, repo-owned skills       | `./install --only link`   |
| config installer | `config/files.json`         | Single files inside directories apps also write to (`~/.claude`, `~/.codex`, `~/.t3`, `~/.config/*`) | `npm run config:install`  |
| skills installer | `config/skills/*.json`      | Agent skills from skills.sh and the personal skills checkout                                         | `npm run skills:install`  |

- dotbot runs with `force: true`: it replaces whatever sits at the target, keeping no backup. The config installer moves a replaced original to `~/.local/state/dotfiles/backups/<timestamp>/`.
- Bare `./install` is the machine bootstrap (Homebrew, sudo prompts, Xcode licence); the user runs it. Use the scoped apply commands above.

A config installer entry is **plain** (target links straight to the source) or **mixed** (it has a `format`: `json`, `toml`, `npmrc`, or `lines`). A mixed source holds only the shareable preferences. Its target links to a generated file in `~/.local/state/dotfiles/generated/`: the source merged with the **private overlay** in `~/.local/state/dotfiles/private/`, which holds every field absent from the source (tokens, account and device IDs, app state). The source owns its keys: each `config:install` resets them, arrays included, so a preference changed inside an app persists only once copied into the source.

## Add a file

1. Read the live file. Its whole content becomes public on GitHub: a file carrying secrets or machine identity goes in as mixed, or stays untracked if no mixed format fits it.
2. Create the source, by convention `config/<tool>/<file>`:
   - dotbot: `mv` the live file into the repo.
   - config installer: `cp` it (the installer reads the live file, then backs it up). For mixed, cut the source down to the shareable keys; the installer captures the rest into the private overlay.
3. Add the manifest entry, copying the shape of its neighbours. `config/files.json` targets are relative to `~`.
4. Apply with the linker's command.

Done when `readlink <target>` points at the source (mixed: at the generated file) and `git status` shows exactly the new source and the manifest.

## Remove a file

1. Delete the manifest entry.
2. Replace the target symlink: to keep the config on this machine, `cp -RL <target> <target>.keep && rm <target> && mv <target>.keep <target>`; to drop it, `rm <target>`.
3. `git rm` the source. For mixed, also delete its files under `generated/` and `private/`.

Done when the target is a regular file or gone, and the manifest and repo hold no trace of it.

## Edit a managed file

Plain and dotbot targets are the repo file: edit either path. Mixed: edit the source, then `npm run config:install`.

## Save to GitHub

1. `git status` and `git diff`. Plain targets are repo files, so changes made by apps and tools surface here as drift. Account for every hunk: yours, or shown to the user.
2. Run `npm test` when `scripts/` or a manifest changed.
3. Commit on `main` as `type(scope): summary`, matching `git log`, then `git push`.

Done when `git status -sb` shows a clean tree level with `origin/main`. Save only when the user asked to; otherwise report the uncommitted change.

## Update from GitHub

1. Save or stash local changes, then `git pull --rebase`.
2. Apply what arrived (`git diff --name-only ORIG_HEAD HEAD`):

| Changed                                   | Run                                                     |
| ----------------------------------------- | ------------------------------------------------------- |
| `install.conf.yaml`                       | `./install --only link`                                 |
| `config/files.json` or a mixed source     | `npm run config:install`                                |
| `package.json`, `package-lock.json`       | `npm ci --ignore-scripts` first                         |
| `config/skills/*`                         | `npm run skills:install`                                |
| `Brewfile`                                | `brew bundle --file Brewfile`                           |
| `setup/*`                                 | Tell the user to run the changed script or `./install`  |

Plain sources and dotbot-linked files are live through their symlinks the moment the pull lands.

## Packages and skills

- `Brewfile` is generated. Install or uninstall with `brew` or `mas`, then regenerate with `node scripts/update-brewfile.mjs` (the user's `bbd` alias). `config/homebrew/mas-blacklist.txt` excludes App Store apps; `config/homebrew/required-casks.txt` retains casks installed outside Homebrew.
- Skills have three homes. skills.sh skills: add with `npx skills add <source> --global`, which updates the linked `config/skills/skill-lock.json`. Personal skills: folders in `~/Developer/skills` (its own Git repo, configured in `config/skills/personal.json`), discovered by `npm run skills:install`. Repo-owned skills: `skills/<name>/` here, linked by dotbot into both `~/.agents/skills/` and `~/.claude/skills/`; this skill is one.

`README-UPDATE.md` documents the Brewfile lists, mixed settings, and skill restoration in full.
