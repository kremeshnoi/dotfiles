# NixOS roadmap

Things not set up yet, roughly in the order they pay off. Suggested start: 1 → 4 → 3, then 2 as a separate piece of work.

## 1. System flake

- Replace the `nixos` / `nixos-wsl` channels with a `flake.nix` + `flake.lock` pinning nixpkgs and NixOS-WSL.
- Build straight from the repo: `sudo nixos-rebuild switch --flake ~/dev/dotfiles#nixos`, so `/etc/nixos` stops being a hand-synced copy of `nixos/configuration.nix`.
- Updates become `nix flake update` + a commit; rollback is a git revert or `nixos-rebuild switch --rollback`.

## 2. home-manager

- Manage zsh, git, neovim, herdr, fzf, zoxide and ssh declaratively instead of the plain-file `.zshrc` that probes `/opt/homebrew` and `/home/linuxbrew` paths.
- Pair it with **nix-darwin** on macOS so `mac/` and `shared/` collapse into one shared config for both machines.

## 3. Per-project dev shells

- Add `direnv` + `nix-direnv`.
- Give each project a `flake.nix` with a `devShell` and an `.envrc`, so toolchains load on `cd` and unload on leave.
- Move language toolchains out of `environment.systemPackages` (jdk17, php, go, dotnet-sdk, clojure, leiningen, cmake, autoconf, automake, bison, re2c, …) into those shells; different projects can then pin different versions.

## 4. Store housekeeping

- `/nix/store` is ~12G with no garbage collection.
- Enable `nix.gc.automatic = true` (e.g. weekly, `--delete-older-than 14d`).
- Enable `nix.optimise.automatic = true` to hardlink identical store files.

## 5. Quality-of-life tools

- **nh** — `nh os switch` with a build tree, a package diff between generations and built-in cleanup of old generations.
- **nix-index + comma** — `, <program>` runs anything from nixpkgs without installing it; command-not-found tells which package provides a missing command.
- **nix-tree / nvd** — inspect what takes up space and diff generations.

## 6. Secrets

- Adopt **sops-nix** or **agenix** for tokens (ngrok, wakatime, railway): encrypted in git, decrypted at activation.

## 7. Drop linuxbrew

- Once home-manager owns the shell, take zsh plugins and fzf from nixpkgs and remove the linuxbrew paths from `.zshrc` and the `fhsWrappers` activation script.

## 8. Single Docker engine

- Both NixOS (`virtualisation.docker`) and Docker Desktop on Windows run an engine.
- If containers are only used from WSL, keep the NixOS engine, remove Docker Desktop and the `7-docker` GlazeWM workspace with it.
