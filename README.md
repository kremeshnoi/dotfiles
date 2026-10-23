# Dotfiles

Configs for two systems — macOS and Windows 11 with NixOS under WSL — plus a shared zsh setup. Every system runs a tiling WM, and the keybinding letters are kept the same across all of them wherever the platform allows it.

```
install.sh                       symlinks the configs into place
mac/glazewm/config.yaml          GlazeWM — tiling WM, same setup as on Windows
mac/glazewm/kill-workspace.sh    quits every app on the focused workspace
mac/swiftbar/glazewm.sh          SwiftBar plugin showing the active GlazeWM workspace
mac/ghostty/config               Ghostty — terminal
mac/herdr/config.toml            herdr — alt as the modifier
windows/                         submodule → win-ricing, the whole Windows rice
nixos/configuration.nix          NixOS-WSL — packages, services, FHS wrappers
nixos/ROADMAP.md                 NixOS features planned but not set up yet
shared/zsh/.zshrc                portable zshrc for macOS / NixOS
shared/shell/env.sh              env, PATH and aliases, sourced by .zshrc
shared/zsh/ohmyzsh/              vendored Oh My Zsh git plugin — git aliases (gst, gco, gp…)
```

The whole Windows side — configs and the rest of the rice — lives in [win-ricing](https://github.com/kremeshnoi/win-ricing) and is pulled in here as the `windows` submodule:

```bash
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git
git submodule update --init   # if already cloned
```

`./install.sh` symlinks the configs into place: the zsh setup everywhere, GlazeWM and the SwiftBar plugin on macOS. It is idempotent, and any existing file it would replace is moved aside as `<name>.backup-<timestamp>`.

## Shared mnemonics

Both systems run [GlazeWM](https://github.com/glzr-io/glazewm) with the same keybindings, `lwin` being `cmd` on macOS: a workspace is focused with `ctrl+shift+<key>` on Windows and `cmd+shift+<key>` on macOS, `ctrl+shift+lwin+<key>` moves the window there, everything else sits on `lwin` on Windows and on `cmd+ctrl` on macOS, so plain `cmd` shortcuts stay with macOS and `alt` stays with herdr and nvim: `cmd+ctrl+hjkl` focuses, `cmd+ctrl+shift+hjkl` moves the window, `cmd+shift+h` / `cmd+shift+l` walk the active workspaces. The workspace set is per platform.

| Workspace | macOS | Windows |
|---|---|---|
| desktop | `0` | `0` |
| system | `y` | `y` |
| term | `t` | `t` |
| edge / chrome | `b` | `b` |
| claude | `a` | `a` |
| slack | `m` | — |
| obsidian | `n` | `n` |
| docker | `c` | `c` |
| tabularis | `d` | `d` |
| spotify | — | `s` |
| discord | — | `x` |
| telegram | — | `m` |
| eve | — | `e` |
| games | — | `g` |
| misc | `9` | `9` |

Both configs route windows by process name, focus follows the routed window, and everything unmatched goes to `misc` through a catch-all rule.

## macOS

[GlazeWM](https://github.com/glzr-io/glazewm) + [Ghostty](https://ghostty.org):

```bash
brew install --cask glzr-io/tap/glazewm swiftbar ghostty
mkdir -p ~/.glzr/glazewm
ln -sf "$PWD/mac/glazewm/config.yaml" ~/.glzr/glazewm/config.yaml
ln -sf "$PWD/mac/glazewm/kill-workspace.sh" ~/.glzr/glazewm/kill-workspace.sh
mkdir -p ~/.config/swiftbar
ln -sf "$PWD/mac/swiftbar/glazewm.sh" ~/.config/swiftbar/glazewm.sh
defaults write com.ameba.SwiftBar PluginDirectory ~/.config/swiftbar
ln -sf "$PWD/mac/ghostty/config" ~/.config/ghostty/config
```

GlazeWM needs Accessibility access (System Settings → Privacy & Security → Accessibility). The `cmd+ctrl` bindings are grabbed system-wide. On macOS `window_process` matches the localized app name (`Microsoft Edge`, `System Settings`), so the rules assume an English system. macOS system apps go to `system`. `cmd+shift+q` runs `kill-workspace.sh`, which jumps to the previous workspace and quits every app on the one it left (Finder windows are only closed). The active workspace is shown in the native menu bar by a streamable SwiftBar plugin that re-renders on `glazewm sub` events; clicking it lists every workspace.

Ghostty runs `macos-option-as-alt = true`, which is what frees Alt for nvim and herdr. Splits are on `cmd+ctrl+hjkl`, creating them adds `shift`.

## Windows

See [win-ricing](https://github.com/kremeshnoi/win-ricing), mounted here as `windows/` — GlazeWM, the AutoHotkey script that kills the Start menu on a lone Win press, four Windhawk mods, herdr navigation over the socket API, Raycast, Spicetify, and removing Xbox Game Bar to free `Win+G`.

## NixOS

The Linux side under WSL is [NixOS-WSL](https://github.com/nix-community/NixOS-WSL), and `nixos/configuration.nix` is the whole system: packages, zsh plugins, Docker, nix-ld for prebuilt binaries, the ssh-agent and `herdr-navd` user units.

```bash
sudo cp nixos/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
ssh-add ~/.ssh/id_ed25519
```

NixOS has no FHS `/usr/bin`, so an activation script compiles a wrapper for every system binary into `/usr/local/bin`, plus `/bin/bash` and `/home/linuxbrew/.linuxbrew/bin/herdr`. `#!/usr/bin/env` scripts and `wsl.exe -e <cmd>` from Windows find their tools that way, and `herdr-nav` keeps the Homebrew path it was written for. envfs solves the same problem lazily, but a lookup through it costs 0.3–1.3 s when called from `wsl.exe`.

`herdr-navd` runs `herdr-nav serve`, which listens on `127.0.0.1:47391`. AutoHotkey sends `tab next` and friends over WinSock, about 0.5 ms per keypress instead of ~120 ms for spawning `wsl.exe`, and falls back to `wsl.exe -e herdr-nav` when the socket is down.

## zsh

`shared/zsh/.zshrc` is the portable version, used on macOS and NixOS.

```bash
ln -sf "$PWD/shared/zsh/.zshrc" ~/.zshrc
mkdir -p ~/.config/zsh
ln -sfn "$PWD/shared/zsh/ohmyzsh" ~/.config/zsh/ohmyzsh
```

Plugins (autosuggestions, fzf, syntax-highlighting) are sourced through a `_try_source` helper that walks a list of candidate paths — Homebrew, Debian, `/usr/local`, nix-profile — and takes the first one that exists, so the same file works everywhere without conditionals per OS. On NixOS none of them match: `programs.zsh` and `programs.fzf` in the system config load the plugins before `.zshrc` runs. Git aliases come from the Oh My Zsh `git` plugin, vendored with its `lib/git.zsh` dependency and MIT licence under `shared/zsh/ohmyzsh/`, so no Oh My Zsh install is needed; it is sourced after `compinit` because it registers completions. Anything machine-specific goes into `~/.zshrc.local`, which is sourced last and never committed.

The prompt is bash-style with a git branch via `vcs_info`. Accent colour `#FFBAF3` is shared with the syntax highlighting.

`.zshrc` sources `shared/shell/env.sh` on its first line, so that file has to be in place or PATH entries, aliases, fzf variables and `SSH_AUTH_SOCK` all silently go missing:

```bash
mkdir -p ~/.config/shell
ln -sf "$PWD/shared/shell/env.sh" ~/.config/shell/env.sh
```

`SSH_AUTH_SOCK` there points at `$XDG_RUNTIME_DIR/ssh-agent.socket`, served by the `ssh-agent` user unit from the NixOS config, which is what stops git from asking for the key passphrase on every push. `~/.ssh/config` carries `AddKeysToAgent yes`, so the passphrase is asked once per WSL start and then never again, and linger keeps the agent alive after the last terminal closes.

## herdr

The same `hjkl` navigation on both systems — `h`/`l` switch tabs, `j`/`k` switch workspaces, adding `shift` switches agents — but reached in two different ways, because only macOS can express it in herdr's own config.

macOS uses `alt`: Ghostty passes Option through as Alt, so herdr sees the combo itself.

```bash
cp mac/herdr/config.toml ~/.config/herdr/config.toml
```

Windows runs the same jumps on `lwin` without touching `[keys]` at all. Win combos never reach a TUI sitting behind the terminal, so AutoHotkey catches the key on the Windows side and hands it to `herdr-nav` running as `herdr-navd` inside NixOS, which drives herdr over its socket API. Those six entries are blanked out in the Windows copy of `config.toml` to keep a single path per action; `prefix = "ctrl+z"` stays for pane navigation, which has no lwin equivalent. Both files live in [win-ricing](https://github.com/kremeshnoi/win-ricing) under `herdr/`, together with the setup notes and the registry policy that frees `Win+L`.
