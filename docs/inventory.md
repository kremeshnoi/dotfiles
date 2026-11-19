# Inventory

Every tracked file, what it does and where it ends up. "Nix" means both NixOS and the Mac with Nix unless stated; "install.sh" means `mac/install.sh` on the Mac without Nix.

## Root

| File | Purpose |
|---|---|
| `README.md` | what the repo is, layout, install commands |
| `LICENSE` | Unlicense |
| `.gitmodules` | `mac` → mac-ricing, `windows` → win-ricing, both over ssh |
| `.claude/CLAUDE.md` | entry point for Claude Code, points here |
| `.github/workflows/flake-check.yml` | the package sync check and `nix flake check ./nix` on every push and PR |
| `.github/scripts/packages.py` | compares the managed packages of the three machines; holds the Nix ↔ Homebrew name map and the exception lists |
| `.github/workflows/update-flake-lock.yml` | weekly `nix flake update --flake ./nix`, opens a PR |

## nix/

| File | Purpose |
|---|---|
| `flake.nix` | inputs (nixpkgs 26.05, nixos-wsl, home-manager, nix-darwin, nix-index-database); `nixosConfigurations.nixos`, `darwinConfigurations.mac`; home-manager for user `kremeshnoi` from `home/` plus `home/darwin/` or `home/nixos/`; formatter and dev shell |
| `flake.lock` | pinned inputs |
| `darwin/configuration.nix` | nix-darwin: herdr and nh as system packages, Homebrew casks (GlazeWM, SwiftBar, the font), nix gc, user, `NH_FLAKE`, SwiftBar plugin dir |
| `nixos/configuration.nix` | NixOS-WSL: herdr and `hx-open-tab` as system packages, Docker, nix-ld, FHS wrappers, `hx-open-tab`, ssh-agent and `herdr-navd` units, `programs.nh.flake` |
| `pkgs/herdr.nix` | herdr release binary per platform, version from `shared/herdr/versions.toml` |
| `pkgs/phpantom.nix` | PHPantom language server release binary per platform |
| `pkgs/lazygit.nix` | lazygit release binary per platform; nixpkgs 26.05 ships 0.61, which predates `git.diffRenderers` |
| `pkgs/delta.nix` | delta release binary per platform; lazygit 0.66 needs delta 0.20 to render the focused diff view, nixpkgs 26.05 ships 0.19 |
| `home/default.nix` | the part every Nix machine shares, with no platform conditions: imports the modules below; user, every tool both machines use, fzf, zoxide, direnv |
| `home/zsh.nix` | zsh with you-should-use and zsh-helix-mode, syntax highlighting; sources `shared/zsh/env.zsh` from `.zshenv`, `startup.zsh` and `rc.zsh` from `.zshrc` |
| `home/git.nix` | git with the user; includes `shared/git/config` |
| `home/ssh.nix` | `~/.ssh/config` with `AddKeysToAgent` |
| `home/bat.nix` | builds the bat cache from `shared/bat` on activation, so bat and delta see the custom syntax themes |
| `home/helix.nix` | Helix wrapped with the language servers; `shared/helix` → `~/.config/helix` |
| `home/herdr.nix` | `~/.config/herdr/config.toml` from `shared/herdr/base.toml`, the keys file the platform sets in `dotfiles.herdrKeys` and the space-colors sidebar; plugin registration on activation |
| `home/claude.nix` | each `shared/claude/skills/<name>` → `~/.claude/skills/<name>` |
| `home/darwin/default.nix` | the Mac with Nix only: its packages, home dir, GlazeWM, kill-workspace, SwiftBar plugin, `keys-macos.toml` for herdr, lazygit and lazydocker configs under `~/Library/Application Support` |
| `home/darwin/glazewm/`, `swiftbar/` | the configs that module places: GlazeWM with the workspaces of the Windows host (Optimum in `terminal`, Zen in `browser`) and the SwiftBar plugin; the work Mac keeps its own in `mac/` |
| `home/nixos/default.nix` | NixOS only: its packages (compilers, runtimes, Docker clients), home dir, `SSH_AUTH_SOCK`, `keys-windows.toml` for herdr, `herdr-nav`, lazygit and lazydocker configs under `~/.config` |
| `home/nixos/herdr-nav` | the socket server AutoHotkey talks to, run by `herdr-navd` → `~/.local/bin/herdr-nav` |
| `home/copy-files.nix` | replaces the home-manager link step with a copy step ([ADR 0002](adr/0002-copy-home-files-instead-of-symlinking.md)) |

## shared/

| File | Purpose | Nix | install.sh |
|---|---|---|---|
| `zsh/env.zsh` | environment and PATH | sourced from `.zshenv` | sourced from `mac/zsh/.zshrc` |
| `zsh/startup.zsh` | fnm, `~/.zshrc.local`, herdr autostart | sourced from `.zshrc` | sourced from `mac/zsh/.zshrc` |
| `zsh/rc.zsh` | history, aliases, completion, prompt, git plugin, fzf widgets, highlight colours | sourced from `.zshrc` | sourced from `mac/zsh/.zshrc` |
| `zsh/dir_colors` | `LS_COLORS` database, the coreutils default | read by `rc.zsh` | read by `rc.zsh` |
| `zsh/fzf-git-branch.zsh` | branch picker on `ctrl+g` / `ctrl+shift+g` | via `rc.zsh` | via `rc.zsh` |
| `zsh/ohmyzsh/` | vendored Oh My Zsh git plugin | via `rc.zsh` | via `rc.zsh` |
| `zsh/zsh-helix-mode/` | vendored Helix keymap for zsh | home-manager plugin | sourced from `mac/zsh/.zshrc` |
| `git/config` | git settings without the user, delta as the pager | included by `home/git.nix` | copied to `~/.config/git/config` |
| `lazygit/config.yml` | lazygit with delta as the diff renderer, without the status panel and the command log | copied to lazygit's default path | copied to `~/Library/Application Support/lazygit/config.yml` |
| `lazydocker/config.yml` | lazydocker shows stopped containers too, returns from commands at once, opens logs with the last 500 lines | copied to lazydocker's default path | not placed yet |
| `bat/themes/GitHub Dark.tmTheme` | syntax theme with the palette of Helix `github_dark`, used by delta | `bat cache --build --source` in `home/bat.nix` | `bat cache --build --source` in `install.sh` |
| `helix/` | Helix config, languages, transparent themes | copied to `~/.config/helix` | copied to `~/.config/helix` |
| `herdr/versions.toml` | herdr version | read by `pkgs/herdr.nix` | read by `install.sh` |
| `herdr/base.toml` | herdr theme, sound and UI for every machine | first part of the config | first part of the config |
| `herdr/keys-windows.toml`, `keys-macos.toml` | herdr keys per OS: blank `lwin` jumps for AutoHotkey, `alt` on macOS | second part, chosen by the platform module | `keys-macos.toml`, second part |
| `herdr/workspace-tabs/` | herdr plugin: five tabs per new workspace | registered from the store | registered from the checkout |
| `herdr/space-colors/` | herdr plugin and `sidebar.toml`: workspace colours by project | plugin registered from the store, `sidebar.toml` appended to the herdr config | — (the work Mac colours by team) |
| `claude/skills/<name>/` | Claude Code skills | copied to `~/.claude/skills/` | copied there |

## mac/ (mac-ricing)

| File | Purpose | Nix (Mac) | install.sh |
|---|---|---|---|
| `Brewfile` | packages and casks for the Mac without Nix | — | `brew bundle` |
| `install.sh` | the whole setup without Nix: copies files, records them in `~/.local/state/dotfiles/copied` | — | — |
| `zsh/.zshrc` | brew shellenv, plugins, sources `shared/zsh` | — | `~/.zshrc`, after a generated line with the path to `shared/` |
| `helix/hx` | `hx` wrapper: Homebrew's language servers first in `PATH` | — | copied to `~/.local/bin/hx` |
| `glazewm/config.yaml` | GlazeWM of the work Mac | — | copied to `~/.glzr/glazewm/` |
| `glazewm/kill-workspace.sh` | quits the apps of the focused workspace | — | copied |
| `swiftbar/glazewm.sh` | active workspace in the menu bar | — | copied to `~/.config/swiftbar/` |
| `ghostty/config` | Ghostty, work Mac only | — | copied to `~/.config/ghostty/` |
| `herdr/space-colors/` | work-only plugin and `sidebar.toml` | — | plugin registered from the checkout, `sidebar.toml` appended to the config |

## windows/ (win-ricing)

No Nix machine reads from here. Everything is applied on the Windows host by hand; see its `docs/`.

## Outside git, on purpose

| File | Holds |
|---|---|
| `~/.zshrc.local` | per-machine environment, `NO_HERDR` |
| `~/.gitconfig` | user name and email on the Mac without Nix |
| `~/.ssh/config` | on the Mac without Nix |

## Checking a machine

On the Nix machines the copied paths are listed in `~/.local/state/home-manager/copied-files`; a path a new generation drops is removed on the next switch. On the work Mac they are listed in `~/.local/state/dotfiles/copied`. A symlink in `$HOME` that points into the repo or `/nix/store` is a leftover: switch or rerun `install.sh` and it becomes a copy.

```bash
find ~ -maxdepth 4 -type l -lname "*dotfiles*" 2>/dev/null
```

The command must print nothing.
