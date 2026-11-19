# herdr

## Files

| File | What it is |
|---|---|
| `shared/herdr/base.toml` | theme, sound and UI for every machine |
| `shared/herdr/keys-macos.toml` | both Macs: `alt` as the modifier, the default `ctrl+b` prefix with the arrows for panes up and down |
| `shared/herdr/keys-windows.toml` | NixOS: the `lwin` jumps blanked out, see below |
| `nix/home/nixos/herdr-nav` | the socket server AutoHotkey talks to, NixOS only |
| `shared/herdr/versions.toml` | herdr version for every machine |
| `shared/herdr/workspace-tabs/` | plugin that lays out every new workspace |
| `shared/herdr/space-colors/` | Nix machines: plugin and sidebar config that colour workspaces by project |
| `mac/herdr/space-colors/` | work Mac only: plugin and sidebar config that colour workspaces by team |

## Versions

`shared/herdr/versions.toml` pins herdr ([ADR 0006](adr/0006-pin-herdr.md)).

- With Nix, `nix/pkgs/herdr.nix` fetches the herdr release binary; the hashes live next to it. An activation step in `nix/home/herdr.nix` runs `herdr plugin link` on each plugin's store path whenever it changes.
- Without Nix, herdr comes from Homebrew and is pinned with `brew pin`; `install.sh` warns when its version differs from the file.

## Plugins

**workspace-tabs** listens to `workspace.created` and turns every new workspace into five tabs in a fixed order — `Claude`, `Code`, `Git`, `Terminal`, `Daemon` — all rooted at the workspace directory, with focus back on `Claude`. The same script runs as the `kremeshnoi.workspace-tabs.bootstrap` action for a workspace that already exists and only adds the tabs it is missing.

**space-colors** on the work Mac (`mac/herdr/space-colors/`) tags each workspace with the team directory under `~/dev/teams/` its panes live in; `sidebar.toml` colours the sidebar by those tags. It is registered on the work Mac only ([ADR 0010](adr/0010-work-only-herdr-sidebar.md)).

On the Nix machines **space-colors** comes from `shared/herdr/space-colors/` and colours by project instead: `color.sh` matches the directory of the first tab of each workspace against `~/dev/otaku-library` blue, `optimum` purple, `turtle-van` green, `edu/clojure-koans` lime, `edu/rustlings` rust, the rest of `edu` yellow, `nvim` teal, `kremeshnoi` orange, `fernbloom` fernbloom, anything else white, `dotfiles` included, on startup and whenever a workspace is created, renamed or focused. `nix/home/herdr.nix` appends its `sidebar.toml` to the herdr config ([ADR 0015](adr/0015-space-colors-on-nix-machines.md)). The `Recolor the workspaces` action runs it by hand.

## Shared behaviour

Both configs keep the same non-key settings by hand, since herdr has no include: the tab bar at the bottom, the native host cursor, agent labels on pane borders, the agent panel sorted by spaces, status shown as symbols, and the theme. A change to one belongs in the other in the same commit.

## Windows

Windows runs the same jumps on `lwin` without touching `[keys]` at all. Win combos never reach a TUI sitting behind the terminal, so AutoHotkey catches the key and hands it to `herdr-nav` running as `herdr-navd` inside NixOS, which drives herdr over its socket API. Those entries are blanked out in `keys-windows.toml` to keep a single path per action, and the default `ctrl+b` prefix with the arrows stays for the up and down neighbours. The registry policy that frees `Win+L` lives in [win-ricing](https://github.com/kremeshnoi/win-ricing). How `herdr-navd` is served is in [architecture.md § NixOS under WSL](architecture.md#nixos-under-wsl).
