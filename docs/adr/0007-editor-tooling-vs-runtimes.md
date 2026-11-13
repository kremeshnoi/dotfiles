# 0007. Editor tooling comes from the system, runtimes from version managers

- Status: accepted
- Date: 2026-11-03

## Context

Helix needs language servers on every machine. Projects need Node, Ruby or Rust at the versions they declare. A project that depends on Nix would not build for anyone else.

## Decision

- Language servers and formatters are editor tooling: they come from Nix (`nix/home/helix.nix`) or Homebrew (`mac/Brewfile`).
- Runtimes and compilers belong to the code: fnm reads `.node-version`, rustup reads `rust-toolchain.toml`, rbenv reads `.ruby-version`.
- With Nix, `hx` is wrapped with the servers prepended to `PATH`, so `npm i -g` or a rustup proxy never shadows them, and they stay out of the shell's `PATH`.
- `rust-analyzer-unwrapped` is used without the Nix `RUST_SRC_PATH`, so `rust-src` and the proc-macro server come from the project's toolchain.

## Consequences

- Projects never depend on Nix.
- The servers still read the project's own libraries and configs: `typescript` and `eslint` from `node_modules`, Prettier's config from the project.
- Without Nix there is no wrapper, so the Homebrew servers are on the shell's `PATH`.
