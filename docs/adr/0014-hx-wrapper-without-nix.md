# 0014. The Mac without Nix wraps `hx` too

- Status: accepted
- Date: 2026-11-13

## Context

[ADR 0007](0007-editor-tooling-vs-runtimes.md) wraps `hx` on the Nix machines so the managed language servers always win. The Mac without Nix had no wrapper: `~/.cargo/bin` comes before Homebrew in `PATH`, so Helix ran the rustup proxy for `rust-analyzer`, which only fell back to Homebrew's server because the toolchain lacked the component. Adding the component would have switched the server on that one machine without anyone noticing.

## Decision

`mac/helix/hx`, linked to `~/.local/bin/hx`, puts `intelephense` and `/opt/homebrew/bin` at the front of `PATH` and runs `/opt/homebrew/bin/hx`. `EDITOR`, `VISUAL` and git's `core.editor` reach it through `PATH`.

## Consequences

- Helix uses the same servers on every machine, whatever rustup or `npm i -g` install.
- Unlike Nix, the servers stay on the shell's `PATH` on this Mac.
- A server installed outside Homebrew needs its directory added to the wrapper.
