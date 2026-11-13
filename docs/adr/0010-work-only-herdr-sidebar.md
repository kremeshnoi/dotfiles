# 0010. The team sidebar in herdr is work-Mac only and generated

- Status: accepted
- Date: 2026-11-13

## Context

On the work Mac the herdr sidebar colours each workspace by the team directory under `~/dev/teams/` its panes live in. That needs the `space-colors` plugin and a `[ui.sidebar.spaces]` section whose rows show the plugin's tokens instead of the workspace name. Without the plugin the same section shows no names at all. herdr reads one config file and has no include.

## Decision

- `mac/herdr/config.toml` is the config for every Mac and has no sidebar section.
- `mac/herdr/space-colors/` holds the plugin and `sidebar.toml` with the section.
- `mac/install.sh` registers the plugin and writes `~/.config/herdr/config.toml` as `config.toml` followed by `sidebar.toml`.
- nix-darwin copies `config.toml` alone and does not register the plugin.

## Consequences

- On the work Mac `~/.config/herdr/config.toml` is a copy, not a link: rerun `install.sh` after editing either file.
- The team names live in a public repo.
