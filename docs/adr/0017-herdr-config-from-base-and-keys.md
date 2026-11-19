# 0017. The herdr config is a shared base plus the keys of the OS

- Status: accepted
- Date: 2026-11-19

## Context

herdr reads one file. Each machine type had its own full copy of it: `windows/herdr/config.toml` for NixOS, `mac/herdr/config.toml` for the work Mac and `nix/home/darwin/herdr/config.toml` for the Mac with Nix. Only the `[keys]` block differed; everything else was repeated three times. NixOS also read that file and `herdr-nav` from the Windows repo.

## Decision

- `shared/herdr/base.toml` holds everything but the keys.
- `shared/herdr/keys-macos.toml` and `shared/herdr/keys-windows.toml` hold the keys of each OS.
- Every machine writes `~/.config/herdr/config.toml` as base, then its keys, then its space-colors sidebar. On Nix `nix/home/herdr.nix` does it and the platform module picks the keys with `dotfiles.herdrKeys`; on the work Mac `install.sh` does it.
- `herdr-nav` lives in `nix/home/nixos/`, next to the module that places it.

## Consequences

- A herdr setting is written once; a key is written once per OS.
- No Nix machine reads from `windows/` any more; [0003](0003-os-specific-rice-in-submodules.md) no longer applies to herdr.
