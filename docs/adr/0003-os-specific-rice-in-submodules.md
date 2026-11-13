# 0003. OS-specific rice lives in submodules

- Status: accepted
- Date: 2026-08-08 for Windows, 2026-11-13 for macOS

## Context

The Windows rice — GlazeWM, AutoHotkey, Windhawk, YASB, the herdr bindings — is useful on its own and has its own README and screenshots. The macOS configs had the same shape and were used by two Macs, one with Nix and one without.

## Decision

- Windows lives in [win-ricing](https://github.com/kremeshnoi/win-ricing), mounted as `windows/`.
- macOS lives in [mac-ricing](https://github.com/kremeshnoi/mac-ricing), mounted as `mac/`.
- Both repos are public, so the submodules clone without credentials and CI can fetch them.
- The Nix side reads OS-specific files straight from the submodule: `windows/herdr/config.toml` on NixOS, `mac/glazewm/…` and `mac/herdr/config.toml` on macOS.

## Consequences

- Every machine on one OS takes the same files from one place.
- A change inside a submodule is two commits: one in the submodule, one bumping it here.
- The flake sets `self.submodules`, so the submodules are part of the build.
