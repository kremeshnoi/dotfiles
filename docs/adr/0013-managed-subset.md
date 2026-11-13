# 0013. The dotfiles manage a subset of each machine, kept in sync by a check

- Status: accepted
- Date: 2026-11-13

## Context

The work Mac carries some 35 Homebrew formulae the repo does not declare: tools for one job, one employer or one experiment. Putting all of them into the repo would make it a dump of every machine; leaving the declared lists to drift apart left real gaps: `bat`, `fnm`, `psql` and `pspg` were on one Mac and not in Nix, while the shared shell called `fnm` everywhere.

## Decision

- The repo declares what every machine of a kind must have; a machine may carry more, and the extras stay out of git.
- The declared sets must not drift: the Mac with Nix and the Mac without Nix declare the same tools, and NixOS declares everything they share. `.github/scripts/packages.py` checks this, mapping names that differ between Nix and Homebrew, and lists the deliberate exceptions: Nix tooling, the NixOS-only toolchain, Mac apps.
- CI runs the check on every push.
- A local extra must not replace or shadow a managed tool; a managed tool that comes from another source on one machine is declared as such in the repo.

## Consequences

- Adding a tool to one side without the other fails CI.
- A tool for NixOS only is a one-line, visible choice in the script.
- Nothing removes extras from a machine; cleaning one up stays manual.
