# 0009. Everything Nix lives under `nix/`

- Status: accepted
- Date: 2026-11-13

## Context

The repo root held `flake.nix`, `flake.lock`, `darwin/`, `home/`, `nixos/`, `pkgs/` and `secrets/` next to `shared/`, `mac/` and `windows/`. It was not clear which files belonged to the Nix setup and which were used by every machine.

## Decision

- The root holds `nix/`, `shared/`, `mac/`, `windows/`, `docs/` and the files every repo has.
- `flake.nix`, `flake.lock`, `darwin/`, `home/`, `nixos/` and `pkgs/` live in `nix/`; the modules reach the rest through `../../`.
- The secrets move to `shared/secrets/`, since the Mac without Nix decrypts them too.

## Consequences

- The flake reference is `~/dev/dotfiles/nix#<host>`; `NH_FLAKE` and `programs.nh.flake` point to `~/dev/dotfiles/nix`.
- `nix fmt`, `nix develop` and `nix flake update` run from `nix/`; CI runs `nix flake check ./nix`.
- Nix copies the whole git repo for a flake in a subdirectory, so `../../shared` and the submodules stay reachable.
