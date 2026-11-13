# 0001. One flake and one home-manager setup for every Nix machine

- Status: accepted
- Date: 2026-10-28, extended to macOS on 2026-11-11

## Context

NixOS under WSL started with its own configuration, and the Mac with a portable `.zshrc`, `shared/shell/env.sh` and an `install.sh` that linked files. The same shell, editor and herdr setup was described twice, and the two drifted.

## Decision

- One flake builds both systems: `nixosConfigurations.nixos` and `darwinConfigurations.mac`.
- Both import the same home-manager configuration from `nix/home/`; differences are guarded by `isDarwin`.
- Inputs are pinned in `flake.lock`; CI checks every push and opens a weekly update pull request.

## Consequences

- A change to the user environment lands on both systems with one switch each.
- Rolling back is a generation switch or a git revert.
- Platform-specific binaries (herdr, reviewr) need a hash per platform.
- A machine that cannot run Nix is not covered; see [0005](0005-mac-without-nix.md).
