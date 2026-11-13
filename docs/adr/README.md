# Architecture decision records

One file per decision that shaped the repo: what was decided, why, and what it costs. A record is not edited once accepted; a later decision supersedes it with a new record and a link back.

| # | Decision | Status |
|---|---|---|
| [0001](0001-one-flake-for-every-nix-machine.md) | One flake and one home-manager setup for every Nix machine | accepted |
| [0002](0002-copy-home-files-instead-of-symlinking.md) | Copy home files instead of symlinking them on Nix machines | accepted |
| [0003](0003-os-specific-rice-in-submodules.md) | OS-specific rice lives in submodules | accepted |
| [0004](0004-shared-holds-os-independent-configs.md) | `shared/` holds only OS-independent configs, installers only place files | accepted |
| [0005](0005-mac-without-nix.md) | A Mac without Nix is set up by Homebrew and symlinks | accepted |
| [0006](0006-pin-herdr-and-reviewr.md) | herdr and reviewr are pinned in one file for every machine | accepted |
| [0007](0007-editor-tooling-vs-runtimes.md) | Editor tooling comes from the system, runtimes from version managers | accepted |
| [0008](0008-secrets-with-sops-and-age.md) | Secrets are encrypted with sops and age | accepted |
| [0009](0009-everything-nix-under-nix.md) | Everything Nix lives under `nix/` | accepted |
| [0010](0010-work-only-herdr-sidebar.md) | The team sidebar in herdr is work-Mac only and generated | accepted |
| [0011](0011-repo-at-dev-dotfiles.md) | The repo lives at `~/dev/dotfiles` on every machine | accepted |

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
