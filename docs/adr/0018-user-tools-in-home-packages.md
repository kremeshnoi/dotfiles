# 0018. User tools live in home.packages, one list per scope

- Status: accepted
- Date: 2026-11-19

## Context

Tools were spread over four lists: `systemPackages` of NixOS and of the Mac, `home.packages`, and the Brewfile. Which list a tool went to had no rule, and the package check needed a hand-kept list of NixOS-only tools.

## Decision

- Every tool both Nix machines use goes to `home.packages` in `nix/home/default.nix`.
- A tool for one Nix machine goes to `home.packages` in `nix/home/nixos/default.nix` or `nix/home/darwin/default.nix`.
- `systemPackages` keeps only what the system calls by path: herdr and `hx-open-tab` on NixOS, herdr and nh on the Mac.
- `.github/scripts/packages.py` compares the Brewfile with the shared list plus the darwin list; NixOS-only tools are not compared.

## Consequences

- One place to add a tool for both Nix machines, and the NixOS-only set is visible in one file instead of in the check.
- Tools move from the system profile to the user profile; their versions do not change.
