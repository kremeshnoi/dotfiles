# Warp

Warp terminal config. Keybindings mirror Ghostty's default Windows/Linux binds
for tab switching, split-by-axis, and pane focus-by-axis.

## Keybindings

| Action | Bind |
|---|---|
| Next / previous tab | `ctrl+tab` / `ctrl+shift+tab` |
| Go to tab 1–9 | `alt+1` … `alt+9` |
| Split right | `ctrl+shift+o` |
| Split down | `ctrl+shift+e` |
| Focus pane by axis | `ctrl+alt+←/→/↑/↓` |

## Install

```sh
./install.sh
```

Copies `keybindings.yaml` into Warp's config directory (auto-detected: `~/.warp`
on macOS, the Windows `AppData/Local/warp/Warp/config` path under WSL, or
`~/.local/state/warp-terminal` on native Linux). An existing file is backed up
first. Restart Warp to apply.
