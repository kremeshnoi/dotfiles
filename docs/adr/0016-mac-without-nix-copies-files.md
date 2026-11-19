# 0016. The Mac without Nix copies files too

- Status: accepted
- Date: 2026-11-19

## Context

`mac/install.sh` linked every file from `$HOME` into the checkout, while the Nix machines copy them ([0002](0002-copy-home-files-instead-of-symlinking.md)). The two machine types behaved differently: an edit in the repo reached the work Mac at once and the other machines only after a switch, and the repo broke its own rule of no symlinks in `$HOME`.

## Decision

- `install.sh` copies each file with `copy` or writes it with `generate`, and lists every path it placed in `~/.local/state/dotfiles/copied`.
- A path from that list is overwritten on the next run; anything else in the way is moved to `<name>.backup-<timestamp>`; an old symlink is replaced by a copy.
- `~/.zshrc` is generated: a first line sets `shared` to the checkout's `shared/`, since a copy can no longer find it through its own path.

## Consequences

- No machine has links into the repo; an edit applies after `install.sh` here, after a switch with Nix.
- The link part of [0005](0005-mac-without-nix.md) no longer holds.
- herdr plugins are still registered from the checkout with `herdr plugin link`: that is herdr's registry, not a file in `$HOME`.
