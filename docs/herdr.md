# herdr

## Files

| File | What it is |
|---|---|
| `mac/herdr/config.toml` | macOS config: `alt` as the modifier, `ctrl+z` prefix with the arrows for panes up and down |
| `windows/herdr/config.toml` | NixOS config: the `lwin` jumps blanked out, see below |
| `windows/herdr/herdr-nav` | the socket client AutoHotkey talks to, NixOS only |
| `shared/herdr/versions.toml` | herdr and reviewr versions for every machine |
| `shared/herdr/reviewr.toml` | reviewr config |
| `shared/herdr/git-review.sh` | the Git Review toggle, installed as `~/.local/bin/herdr-git-review` |
| `shared/herdr/workspace-tabs/` | plugin that lays out every new workspace |
| `mac/herdr/space-colors/` | work Mac only: plugin and sidebar config that colour workspaces by team |

## Versions

`shared/herdr/versions.toml` pins herdr and reviewr ([ADR 0006](adr/0006-pin-herdr-and-reviewr.md)).

- With Nix, `nix/pkgs/herdr.nix` fetches the herdr release binary and `nix/home/herdr.nix` builds the reviewr plugin root from the release binary and the manifest of that tag; the hashes live next to them. An activation step runs `herdr plugin link` on the store path whenever it changes. The root is read-only, which reviewr is fine with: it only writes under `~/.local/state` and `~/.local/bin`.
- Without Nix, herdr comes from Homebrew and is pinned with `brew pin`; `install.sh` warns when its version differs from the file and installs reviewr with `herdr plugin install --ref v<version>`.

## Plugins

**reviewr** ([persiyanov/herdr-reviewr](https://github.com/persiyanov/herdr-reviewr)) shows the agent's diff in a pane, lets you comment on lines and sends the comments back to the agent. It opens in its own tab, set by `toggle_placement` in `reviewr.toml`. reviewr always names that tab `reviewr`, so the toggle goes through `git-review.sh`, which waits for that tab, renames it to `Git Review` and focuses it; on Windows `herdr-nav reviewr` does the same.

**workspace-tabs** listens to `workspace.created` and turns every new workspace into five tabs in a fixed order — `Claude`, `Code`, `Terminal`, `Git`, `Daemon` — all rooted at the workspace directory, with focus back on `Claude`. The same script runs as the `kremeshnoi.workspace-tabs.bootstrap` action for a workspace that already exists and only adds the tabs it is missing.

**space-colors** tags each workspace with the team directory under `~/dev/teams/` its panes live in; `sidebar.toml` colours the sidebar by those tags. It is registered on the work Mac only ([ADR 0010](adr/0010-work-only-herdr-sidebar.md)).

## Shared behaviour

Both configs keep the same non-key settings by hand, since herdr has no include: the tab bar at the bottom, the native host cursor, agent labels on pane borders, the agent panel sorted by spaces, status shown as symbols, and the theme. A change to one belongs in the other in the same commit.

## Windows

Windows runs the same jumps on `lwin` without touching `[keys]` at all. Win combos never reach a TUI sitting behind the terminal, so AutoHotkey catches the key and hands it to `herdr-nav` running as `herdr-navd` inside NixOS, which drives herdr over its socket API. Those entries are blanked out in the Windows copy of `config.toml` to keep a single path per action, and `prefix = "ctrl+z"` with the arrows stays for the up and down neighbours. The setup notes and the registry policy that frees `Win+L` live in [win-ricing](https://github.com/kremeshnoi/win-ricing) under `herdr/`. How `herdr-navd` is served is in [nixos.md](nixos.md).
