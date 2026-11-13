# 0004. `shared/` holds only OS-independent configs, installers only place files

- Status: accepted
- Date: 2026-11-13

## Context

Adding a Mac without Nix meant the zsh and git settings were written twice: once as home-manager options, once in plain files for Homebrew. The question was where a config used by several setups should live.

## Decision

- A file that works on any OS lives in `shared/`: zsh, git, Helix, herdr scripts and plugins, Claude skills, secrets.
- A file that works on one OS lives in that OS's submodule, even when several machines use it ([0003](0003-os-specific-rice-in-submodules.md)).
- `nix/home/*.nix` and `mac/install.sh` only place files: copy, link, generate. Settings are not written inline there.
- zsh is split into `shared/zsh/env.zsh`, `startup.zsh` and `rc.zsh`; home-manager and `mac/zsh/.zshrc` source them and add only the plugin sources that differ.
- git settings live in `shared/git/config`; home-manager includes it and adds the user.

## Consequences

- A shell or git change is made once and reaches every machine.
- Package lists cannot be shared: Nix and Homebrew names differ, so `mac/Brewfile` and the Nix lists are separate; [0013](0013-managed-subset.md) adds a check that keeps them in sync.
- home-manager options that only switch a feature on (`syntaxHighlighting.enable`) stay in Nix; their values come from `shared/`.
