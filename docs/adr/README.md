# Architecture decision records

One file per decision that shaped the repo: what was decided, why, and what it costs. A record is not edited once accepted; a later decision supersedes it with a new record and a link back.

| # | Decision | Status |
|---|---|---|
| [0001](0001-one-flake-for-every-nix-machine.md) | One flake and one home-manager setup for every Nix machine | accepted |
| [0002](0002-copy-home-files-instead-of-symlinking.md) | Copy home files instead of symlinking them on Nix machines | accepted |
| [0003](0003-os-specific-rice-in-submodules.md) | OS-specific rice lives in submodules | accepted, amended by 0017 |
| [0004](0004-shared-holds-os-independent-configs.md) | `shared/` holds only OS-independent configs, installers only place files | accepted |
| [0005](0005-mac-without-nix.md) | A Mac without Nix is set up by Homebrew and symlinks | links superseded by 0016 |
| [0006](0006-pin-herdr.md) | herdr is pinned in one file for every machine | accepted |
| [0007](0007-editor-tooling-vs-runtimes.md) | Editor tooling comes from the system, runtimes from version managers | accepted |
| [0008](0008-secrets-with-sops-and-age.md) | Secrets are encrypted with sops and age | superseded by 0012 |
| [0009](0009-everything-nix-under-nix.md) | Everything Nix lives under `nix/` | accepted, amended by 0019 |
| [0010](0010-work-only-herdr-sidebar.md) | The team sidebar in herdr is work-Mac only and generated | accepted, amended by 0017 |
| [0011](0011-repo-at-dev-dotfiles.md) | The repo lives at `~/dev/dotfiles` on every machine | accepted |
| [0012](0012-dropped-tools.md) | neovim, wakatime, Ruby, herdr goto and the claude wrapper are dropped | accepted |
| [0013](0013-managed-subset.md) | The dotfiles manage a subset of each machine, kept in sync by a check | accepted, amended by 0018 |
| [0014](0014-hx-wrapper-without-nix.md) | The Mac without Nix wraps `hx` too | accepted |
| [0015](0015-space-colors-on-nix-machines.md) | The Nix machines colour herdr workspaces by project | accepted |
| [0016](0016-mac-without-nix-copies-files.md) | The Mac without Nix copies files too | accepted |
| [0017](0017-herdr-config-from-base-and-keys.md) | The herdr config is a shared base plus the keys of the OS | accepted |
| [0018](0018-user-tools-in-home-packages.md) | User tools live in home.packages, one list per scope | accepted |
| [0019](0019-nix-in-its-own-repo.md) | `nix/` is its own repo | accepted |

## Template

```markdown
# NNNN. Title

- Status: proposed | accepted | superseded by NNNN
- Date: YYYY-MM-DD

## Context

What forces the decision: the problem, the constraints, what was tried.

## Decision

What we do, stated so it can be checked.

## Consequences

What gets easier, what gets harder, what has to be done by hand from now on.
```
