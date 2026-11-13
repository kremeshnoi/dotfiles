# 0002. Copy home files instead of symlinking them on Nix machines

- Status: accepted
- Date: 2026-11-11

## Context

home-manager links every managed file from `$HOME` into the Nix store, and some configs were linked straight into the repo for live edits. The result was a home directory made of links into two different places, read-only ones among them.

## Decision

On the Nix machines every managed file in `$HOME` is a real copy:

- `nix/home/copy-files.nix` replaces the home-manager link step with a copy step;
- the copied paths are recorded in `~/.local/state/home-manager/copied-files`, and paths a new generation drops are removed;
- a foreign file in the way is moved aside as `<name>.hm-backup`.

## Consequences

- Files in `$HOME` are writable and look like ordinary files to every tool.
- A repo edit applies only after a switch, the Helix config and the Claude skills included.
- `config.lib.file.mkOutOfStoreSymlink` would be copied too, since the copy step follows links; a live link on a Nix machine needs a change to `copy-files.nix` first.
- The Mac without Nix uses links instead; see [0005](0005-mac-without-nix.md).
