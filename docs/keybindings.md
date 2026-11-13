# Keybindings

## GlazeWM

Both systems run [GlazeWM](https://github.com/glzr-io/glazewm) with the same keybindings on the same physical keys: Ctrl and Alt are swapped in the Windows keyboard firmware, so `cmd` sits where Windows has `ctrl` and the Mac `ctrl` where Windows has `alt`.

| Action | macOS | Windows |
|---|---|---|
| focus a workspace | `cmd+shift+<key>` | `ctrl+shift+<key>` |
| move the window to a workspace | `cmd+ctrl+shift+<key>` | `ctrl+alt+shift+<key>` |
| new terminal | `cmd+enter` | `ctrl+enter` |
| focus left / down / up / right | `cmd+ctrl+hjkl` | `ctrl+alt+hjkl` |
| move the window | `cmd+ctrl+shift+hjkl` | `ctrl+alt+shift+hjkl` |
| previous / next active workspace | `cmd+shift+h` / `cmd+shift+l` | `ctrl+shift+h` / `ctrl+shift+l` |

Everything else sits on `cmd+ctrl` on macOS and on `ctrl+alt` on Windows, so herdr keeps its modifier to itself: Option on the Mac, `lwin` on Windows, which is the same physical key.

| Workspace | macOS | Windows |
|---|---|---|
| desktop | `0` | `0` |
| system | `y` | `y` |
| term | `t` | `t` |
| edge / browser | `b` | `b` |
| claude | `a` | — |
| slack | `m` | — |
| obsidian | `n` | `n` |
| docker | `c` | `c` |
| tabularis | `d` | — |
| spotify | — | `s` |
| discord | — | `x` |
| telegram | — | `m` |
| eve | — | `e` |
| games | — | `g` |
| misc | `9` | `9` |

Both configs route windows by process name, focus follows the routed window, and everything unmatched goes to `misc` through a catch-all rule.

### macOS specifics

- The `cmd+ctrl` bindings are grabbed system-wide.
- `window_process` matches the localized app name (`Microsoft Edge`, `System Settings`), so the rules assume an English system. macOS system apps go to `system`.
- `cmd+shift+q` runs `kill-workspace.sh`, which jumps to the previous workspace and quits every app on the one it left; Finder windows are only closed. GlazeWM runs commands from `/`, so the binding calls the script through `bash -c $HOME/...`.
- Ghostty looks like Windows Terminal on the Windows host: `JetBrainsMono Nerd Font`, the `Hyper` palette, a bar cursor, 85% opacity, bold text in bright colours. The font comes from the `font-jetbrains-mono-nerd-font` cask on both Macs.
- The active workspace is shown in the menu bar by a streamable SwiftBar plugin that re-renders on `glazewm sub` events; clicking it lists every workspace.
- Ghostty runs `macos-option-as-alt = true`, which frees Alt for herdr and Helix. Splits are on `cmd+ctrl+hjkl`, creating them adds `shift`.

## herdr

The same navigation on both systems: `h`/`l` switch tabs, `j`/`k` switch workspaces, adding `shift` switches agents with `j`/`k` and panes with `h`/`l`.

| Action | macOS | Windows |
|---|---|---|
| tabs | `alt+h` / `alt+l` | `lwin+h` / `lwin+l` |
| workspaces | `alt+j` / `alt+k` | `lwin+j` / `lwin+k` |
| agents | `alt+shift+j` / `alt+shift+k` | `lwin+shift+j` / `lwin+shift+k` |
| panes | `alt+shift+h` / `alt+shift+l` | `lwin+shift+h` / `lwin+shift+l` |
| reviewr | `alt+shift+r` | `lwin+shift+r` |
| pane up / down | `ctrl+z` then `up` / `down` | `ctrl+z` then `up` / `down` |

macOS reaches them in herdr's own config. On Windows, Win combos never reach a TUI behind the terminal, so AutoHotkey catches them and hands them to `herdr-nav`, see [herdr.md](herdr.md).
