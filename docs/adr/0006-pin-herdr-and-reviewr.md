# 0006. herdr and reviewr are pinned in one file for every machine

- Status: accepted
- Date: 2026-11-13

## Context

The Nix machines pinned herdr and reviewr in two Nix files, while the Mac without Nix took whatever Homebrew and `herdr plugin install` gave. The herdr config and the plugins depend on the herdr version, so the machines could drift apart.

Downloading the herdr release binary on the work Mac does not work: macOS kills a freshly downloaded copy with `SIGKILL` (`Killed: 9`, exit 137) even though its signature is valid, while the same bytes run from `/tmp` and the Homebrew build runs everywhere.

## Decision

- `shared/herdr/versions.toml` holds the herdr and reviewr versions.
- Nix reads it with `builtins.fromTOML` in `nix/pkgs/herdr.nix` and `nix/home/herdr.nix`; the hashes stay next to them.
- The Mac without Nix takes herdr from Homebrew, pinned with `brew pin`; `install.sh` warns when it differs from the file, and installs reviewr with `herdr plugin install --ref v<version>`.

## Consequences

- A bump is one version line plus the Nix hashes.
- Homebrew can lag behind or run ahead of a release; the warning in `install.sh` is the only guard there.
