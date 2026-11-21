---
name: resync-dotfiles
description: Bring this Mac level with the dotfiles on GitHub, then report leftover local changes.
disable-model-invocation: true
---

# Resync dotfiles

Bring `~/.dotfiles` level with `origin/main` and this Mac level with the repo. Run everything from `~/.dotfiles`. Load the `dotfiles` skill first: its **Update from GitHub** table maps each changed path to its apply command.

## 1. Stash

Run `git status --short`. Clean tree: skip this step and step 4.

Otherwise record the dirty file list, then `git stash push --include-untracked -m resync-dotfiles`.

Done when `git status --short` is empty and `git stash list` shows the `resync-dotfiles` entry on top.

## 2. Pull

Record `git rev-parse HEAD` as the old `HEAD` (an up-to-date pull leaves `ORIG_HEAD` stale), then `git pull --rebase origin main`.

Done when `git status -sb` shows `main` level with `origin/main`.

## 3. Apply

List what arrived with `git diff --name-only <old HEAD> HEAD`. Run every apply command the `dotfiles` table maps those paths to, in table order (`npm ci --ignore-scripts` first). Changed `setup/*` scripts and bare `./install` belong to the user: name them in the report.

Fix each failure at its cause, then rerun the command. A fix that needs a repo edit stays uncommitted and goes in the report. A failure needing the user (sudo, sign-in, network) goes in the report verbatim.

Done when every mapped command has exited 0 or is reported with its full error.

## 4. Unstash

`git stash pop`. A conflicted pop keeps the stash: resolve each file keeping both sides' intent, `git add` it, then `git reset -q` (pop leaves files staged) and `git stash drop`.

Done when the stashed changes sit in the working tree and the `resync-dotfiles` stash is gone.

## 5. Report

- Commits pulled (`git log --oneline <old HEAD>..HEAD`) and commands run.
- Every failure left for the user, with its error.
- Every stashed file (step 1's list), with its `git diff --stat` or untracked status. Plain sources are live files, so many are drift written by apps. For each, recommend **commit** (a real preference change, saved per the `dotfiles` skill's **Save to GitHub**) or **prune** (`git restore <file>`, or `rm` for untracked noise), then wait for the user's call.

Done when the user has every pulled change, every outstanding failure, and a commit-or-prune recommendation for every stashed file.
