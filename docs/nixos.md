# NixOS under WSL

The Linux side is [NixOS-WSL](https://github.com/nix-community/NixOS-WSL), built from `nix/flake.nix`. The flake pins nixpkgs, NixOS-WSL, nix-darwin, home-manager, nix-index-database and pgf in `nix/flake.lock`. `nix/nixos/configuration.nix` holds the system — packages, Docker, nix-ld for prebuilt binaries, the ssh-agent and `herdr-navd` user units — and `nix/home/` holds the user side.

## Housekeeping

- Channels are disabled; `nixos-rebuild switch --rollback` or a git revert undoes a change.
- The store is garbage-collected weekly (`--delete-older-than 14d`) and optimised by systemd timers.
- `, <program>` runs anything from nixpkgs without installing it; the prebuilt nix-index database also answers command-not-found.
- `nix-tree` and `nvd` show what takes up space and what changed between generations.
- From `nix/`, `nix fmt` formats the Nix files with nixfmt and `nix develop` opens a shell with nixfmt and nvd.

## FHS wrappers

NixOS has no FHS `/usr/bin`, so an activation script compiles a wrapper for every system binary into `/usr/local/bin`, plus `/bin/bash`. `#!/usr/bin/env` scripts and `wsl.exe -e <cmd>` from Windows find their tools that way. envfs solves the same problem lazily, but a lookup through it costs 0.3–1.3 s when called from `wsl.exe`.

## herdr-navd

`herdr-navd` runs `herdr-nav serve`, which listens on `127.0.0.1:47391`. AutoHotkey sends `tab next` and friends over WinSock, about 0.5 ms per keypress instead of ~120 ms for spawning `wsl.exe`, and falls back to `wsl.exe -e herdr-nav` when the socket is down.

## Opening files from Explorer

Opening a text file from Explorer lands in Helix: `windows/terminal/install-helix-open.ps1` points the text extensions at `helix-open.vbs`, which focuses Optimum and runs `hx-open-tab` from `nix/nixos/configuration.nix`. That script opens a herdr tab named after the file, rooted at its git repository, and starts `hx` there.

The extension list comes from a scan of every drive and covers text, config and source formats, Steam's `.vdf`/`.acf` included, while scripts that run on double-click (`.bat`, `.cmd`, `.vbs`, `.ahk`, `.reg`) are left alone. The installer finds `optimum.exe` in Program Files or in the per-user install, passes its path to the launcher and uses it for the Open with icon, and drops the per-user choice Windows stores for each extension, so `Ctrl+,` in Optimum opens `config.toml` in Helix as well. Extensions it still cannot claim are listed at the end and have to be switched once through Open with → Always; `-Uninstall` reverts the rest.

## Docker

Docker runs on the NixOS engine only, `lazydocker` is the dashboard.
