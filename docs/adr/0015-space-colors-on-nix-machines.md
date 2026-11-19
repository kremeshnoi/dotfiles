# 0015. The Nix machines colour herdr workspaces by project

- Status: accepted
- Date: 2026-11-13

## Context

NixOS coloured each workspace in the herdr sidebar by the project under `~/dev` it lives in, through a plugin and a config override kept outside the repo. The switch to the managed config dropped both, and the colours went with them. The work Mac colours by team instead ([0010](0010-work-only-herdr-sidebar.md)), and a sidebar shows the tokens of one plugin only.

## Decision

- `shared/herdr/space-colors/` holds the plugin and `sidebar.toml`: `color.sh` maps the directory of a workspace's first tab to a colour token, `sidebar.toml` colours the sidebar by those tokens.
- `nix/home/herdr.nix` registers the plugin and writes `~/.config/herdr/config.toml` as the OS config followed by `sidebar.toml`, on NixOS and on the Mac with Nix.
- `mac/install.sh` does not take it: the work Mac keeps the team colours from `mac/herdr/space-colors/`.

## Consequences

- `~/.config/herdr/config.toml` is generated on every machine; an edit to `sidebar.toml` applies after a switch.
- A new project gets its colour in the `case` of `color.sh`; a new colour also needs a row in `sidebar.toml`.
- The project names live in a public repo.
