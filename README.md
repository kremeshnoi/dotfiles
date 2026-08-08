# dotfiles

Configs for three systems — macOS, Windows 11 and NixOS — plus a shared zsh setup. Every system runs a tiling WM, and the keybinding letters are kept the same across all of them wherever the platform allows it.

```
mac/aerospace/aerospace.toml     AeroSpace — tiling WM
mac/ghostty/config               Ghostty — terminal
mac/herdr/config.toml            herdr — alt as the modifier
windows/                         submodule → win-ricing, the whole Windows rice
nixos/                           flake, NixOS + home-manager, Hyprland
zsh/.zshrc                       portable zshrc for macOS / WSL / Debian
shell/env.sh                     env, PATH and aliases, sourced by .zshrc
wsl/ssh-agent.service            systemd user unit keeping the SSH key unlocked
```

The whole Windows side — configs and the rest of the rice — lives in [win-ricing](https://github.com/kremeshnoi/win-ricing) and is pulled in here as the `windows` submodule:

```bash
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git
git submodule update --init   # if already cloned
```

## Shared mnemonics

| Workspace | macOS | Windows |
|---|---|---|
| term | `cmd+shift+t` | `lwin+t` |
| chrome | `cmd+shift+g` | `lwin+g` |
| claude | `cmd+shift+c` | `lwin+c` |
| obsidian | `cmd+shift+o` | `lwin+o` |
| slack / spotify | `cmd+shift+s` | `lwin+s` |
| misc | `cmd+shift+9` | `lwin+9` |
| desktop | `cmd+shift+0` | `lwin+0` |

The letter follows the app name; digits sit at the edges of the number row. Modifiers differ because each platform leaves a different one free: `cmd+shift` on macOS, `lwin` on Windows (see [win-ricing](https://github.com/kremeshnoi/win-ricing) for why), `SUPER` on Hyprland.

Both WM configs route windows by app id / process name and send everything unmatched to `misc` through a catch-all rule.

## macOS

[AeroSpace](https://github.com/nikitabobko/AeroSpace) + [Ghostty](https://ghostty.org):

```bash
brew install --cask nikitabobko/tap/aerospace ghostty
ln -sf "$PWD/mac/aerospace/aerospace.toml" ~/.config/aerospace/aerospace.toml
ln -sf "$PWD/mac/ghostty/config" ~/.config/ghostty/config
```

AeroSpace starts at login (`start-at-login = true`) and triggers a sketchybar event on workspace change — drop `exec-on-workspace-change` if sketchybar isn't installed. `cmd+shift+;` enters service mode: `esc` reloads the config, `r` flattens the layout, `f` toggles floating/tiling, `hjkl` join with a neighbour, `backspace` closes every window but the current one.

Ghostty runs `macos-option-as-alt = true`, which is what frees Alt for nvim and herdr. Splits are on `cmd+ctrl+hjkl`, creating them adds `shift`.

## Windows

See [win-ricing](https://github.com/kremeshnoi/win-ricing), mounted here as `windows/` — GlazeWM, the AutoHotkey script that kills the Start menu on a lone Win press, four Windhawk mods, herdr navigation over the socket API, Raycast, Spicetify, and removing Xbox Game Bar to free `Win+G`.

## NixOS

Flake with home-manager, host `alex-nixos`, user `alex`. Hyprland + [caelestia](https://github.com/caelestia-dots/shell) as the shell, greetd for login, PipeWire for audio, NVIDIA drivers.

```bash
sudo nixos-rebuild switch --flake .#alex-nixos
```

`nixos/configuration.nix` is system-level, `nixos/home.nix` is home-manager (Hyprland settings included), `nixos/home/shell.nix` is the zsh config, `nixos/home/packages.nix` is the user package list. `hardware-configuration.nix` is machine-specific and won't transfer to another box.

Hyprland uses `SUPER` for workspaces `1..4` and `SUPER+hjkl` for focus; `ALT` handles the launcher, terminal and window close, so the Alt-based navigation matches the other systems.

## zsh

`zsh/.zshrc` is the portable version, used on macOS, WSL and Debian. NixOS doesn't use it — there zsh is generated from `nixos/home/shell.nix`, with the same history, plugin and highlighting settings.

```bash
ln -sf "$PWD/zsh/.zshrc" ~/.zshrc
```

Plugins (autosuggestions, fzf, syntax-highlighting) are sourced through a `_try_source` helper that walks a list of candidate paths — Homebrew, Debian, `/usr/local`, nix-profile — and takes the first one that exists, so the same file works everywhere without conditionals per OS. Anything machine-specific goes into `~/.zshrc.local`, which is sourced last and never committed.

The prompt is bash-style with a git branch via `vcs_info`. Accent colour `#FFBAF3` is shared with the syntax highlighting.

`.zshrc` sources `shell/env.sh` on its first line, so that file has to be in place or PATH entries, aliases, fzf variables and `SSH_AUTH_SOCK` all silently go missing:

```bash
cp shell/env.sh ~/.config/shell/env.sh
```

`SSH_AUTH_SOCK` there points at an agent started by systemd, which is what stops git from asking for the key passphrase on every push. WSL runs systemd with a user session, so the unit works as-is:

```bash
cp wsl/ssh-agent.service ~/.config/systemd/user/ssh-agent.service
systemctl --user enable --now ssh-agent.service
loginctl enable-linger "$USER"
ssh-add ~/.ssh/id_ed25519
```

`~/.ssh/config` carries `AddKeysToAgent yes`, so the passphrase is asked once per WSL start and then never again. `enable-linger` keeps the agent alive after the last terminal closes.

## herdr

The same `hjkl` navigation on both systems — `h`/`l` switch tabs, `j`/`k` switch agents, adding `shift` switches workspaces — but reached in two different ways, because only macOS can express it in herdr's own config.

macOS uses `alt`: Ghostty passes Option through as Alt, so herdr sees the combo itself.

```bash
cp mac/herdr/config.toml ~/.config/herdr/config.toml
```

Windows runs the same jumps on `lwin` without touching `[keys]` at all. Win combos never reach a TUI sitting behind the terminal, so AutoHotkey catches the key on the Windows side and calls `herdr-nav`, which drives herdr over its socket API. Those six entries are blanked out in the Windows copy of `config.toml` to keep a single path per action; `prefix = "ctrl+z"` stays for pane navigation, which has no lwin equivalent. Both files live in [win-ricing](https://github.com/kremeshnoi/win-ricing) under `herdr/`, together with the setup notes and the registry policy that frees `Win+L`.
