# 0011. The repo lives at `~/dev/dotfiles` on every machine

- Status: accepted
- Date: 2026-11-13

## Context

The Nix machines kept the checkout at `~/dev/dotfiles/dotfiles`, the work Mac at `~/dev/dotfiles`. `NH_FLAKE`, the README and the install script disagreed about where the repo is.

## Decision

Every machine keeps the checkout at `~/dev/dotfiles`.

## Consequences

- One path in the docs, in `NH_FLAKE` and in `programs.nh.flake`.
- An existing checkout at `~/dev/dotfiles/dotfiles` has to be moved once before the next switch.
