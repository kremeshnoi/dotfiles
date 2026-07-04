# AeroSpace Config

Config for the [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling window manager (macOS).

## What's in it

- Named persistent workspaces: `desktop`, `term`, `misc`, `slack`, `claude`, `chrome`, `obsidian`, `docker` — all force-assigned to monitor 1
- Apps auto-routed to workspaces on launch (Ghostty→term, Slack→slack, Claude→claude, Chrome→chrome, Obsidian→obsidian, Docker→docker, everything else→misc)
- Zero gaps, tiles layout, `sketchybar` workspace-change trigger, start at login
- `cmd-shift` bindings for focus (`hjkl`), workspace switching, resize, and layout
- `service` mode (`cmd-shift-;`) for reload, join, flatten, close-others

## Install

```sh
./install.sh
```

The installer backs up any existing config and symlinks `aerospace.toml` → `~/.config/aerospace/aerospace.toml`.

AeroSpace itself:

```sh
brew install --cask nikitabobko/tap/aerospace
```

## License

[Unlicense](../LICENSE) — public domain.
