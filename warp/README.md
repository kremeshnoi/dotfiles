# Warp

Warp terminal config. Split keybindings mirror my Ghostty config's vim-`hjkl`
scheme (navigate with the base combo, create a split by adding `shift`).

## Keybindings

| Action | Bind |
|---|---|
| Next / previous tab | `ctrl+tab` / `ctrl+shift+tab` |
| Go to tab 1–9 | `alt+1` … `alt+9` |
| Focus split left/down/up/right | `ctrl+alt+h/j/k/l` |
| New split left/down/up/right | `ctrl+alt+shift+h/j/k/l` |

## Install

```sh
./install.sh
```

Copies `keybindings.yaml` and `settings.toml` into Warp's config directory
(auto-detected: `~/.warp` on macOS, the Windows `AppData/Local/warp/Warp/config`
path under WSL, or `~/.local/state/warp-terminal` on native Linux). An existing
file is backed up first only when it differs. Restart Warp to apply.

Edit the files in this directory, then re-run `./install.sh` to push changes to
Warp. Warp only reads these files at startup, so restart it after installing.

## Keystroke encoding gotchas

Warp normalizes triggers and **silently drops any binding it can't parse**, so
get these exact:

- Single-letter key with `shift` → the letter must be **uppercase**:
  `ctrl-shift-O`, never `ctrl-shift-o`. Without `shift` it stays lowercase.
- Special keys (`tab`, `space`, `enter`, arrows, `f1`–`f20`, …) stay lowercase
  even with `shift`: `ctrl-shift-tab`, not `ctrl-shift-TAB`.
- Modifier order: `ctrl-alt-shift-cmd-meta-`. Use `cmdorctrl-` for cross-platform.
- Set a value to `none` to unbind a default action.

Defaults are compiled into Warp and aren't listed in the file. To find an action
name, use **Settings → Keyboard Shortcuts** (search by description or current
key) — it shows the canonical `namespace:action_name`.
