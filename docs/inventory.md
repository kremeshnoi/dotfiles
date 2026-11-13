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
| `flake.nix` | inputs (nixpkgs 26.05, nixos-wsl, home-manager, nix-darwin, nix-index-database, pgf); `nixosConfigurations.nixos`, `darwinConfigurations.mac`; home-manager for user `kremeshnoi` with the pgf module; formatter and dev shell |
| `flake.lock` | pinned inputs |
| `darwin/configuration.nix` | nix-darwin: system packages, Homebrew casks (GlazeWM, SwiftBar, Ghostty), nix gc, user, `NH_FLAKE`, SwiftBar plugin dir |
| `nixos/configuration.nix` | NixOS-WSL: system packages, Docker, nix-ld, FHS wrappers, `hx-open-tab`, ssh-agent and `herdr-navd` units, `programs.nh.flake` |
| `pkgs/herdr.nix` | herdr release binary per platform, version from `shared/herdr/versions.toml` |
| `home/default.nix` | imports the modules below; user, home dir, a few packages, `SSH_AUTH_SOCK` on Linux, fzf, pgf, zoxide, direnv |
| `home/zsh.nix` | zsh with you-should-use and zsh-helix-mode, syntax highlighting; sources `shared/zsh/env.zsh` from `.zshenv`, `startup.zsh` and `rc.zsh` from `.zshrc` |
| `home/git.nix` | git with lfs and the user; includes `shared/git/config` |
| `home/ssh.nix` | `~/.ssh/config` with `AddKeysToAgent` |
| `home/helix.nix` | Helix wrapped with the language servers; `shared/helix` → `~/.config/helix` |
| `home/herdr.nix` | herdr config from `mac/` or `windows/`, herdr scripts from `shared/`, reviewr plugin from its release, plugin registration on activation |
| `home/claude.nix` | each `shared/claude/skills/<name>` → `~/.claude/skills/<name>` |
| `home/darwin.nix` | macOS only: GlazeWM, kill-workspace, SwiftBar plugin, Ghostty from `mac/` |
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
| `git/config` | git settings without the user | included by `home/git.nix` | linked to `~/.config/git/config` |
| `helix/` | Helix config, languages, transparent themes | copied to `~/.config/helix` | linked to `~/.config/helix` |
| `herdr/versions.toml` | herdr and reviewr versions | read by `pkgs/herdr.nix`, `home/herdr.nix` | read by `install.sh` |
| `herdr/reviewr.toml` | reviewr config | copied | linked |
| `herdr/git-review.sh` | Git Review toggle | `~/.local/bin/herdr-git-review` | linked there |
| `herdr/workspace-tabs/` | herdr plugin: five tabs per new workspace | linked from the store | linked from the checkout |
| `claude/skills/<name>/` | Claude Code skills | copied to `~/.claude/skills/` | linked there |

## mac/ (mac-ricing)

| File | Purpose | Nix (Mac) | install.sh |
|---|---|---|---|
| `Brewfile` | packages and casks for the Mac without Nix | — | `brew bundle` |
| `install.sh` | the whole setup without Nix | — | — |
| `zsh/.zshrc` | brew shellenv, libpq PATH, plugins, sources `shared/zsh` | — | linked to `~/.zshrc` |
| `helix/hx` | `hx` wrapper: managed language servers first in `PATH` | — | linked to `~/.local/bin/hx` |
| `glazewm/config.yaml` | GlazeWM | copied to `~/.glzr/glazewm/` | linked there |
| `glazewm/kill-workspace.sh` | quits the apps of the focused workspace | copied | linked |
| `swiftbar/glazewm.sh` | active workspace in the menu bar | copied to `~/.config/swiftbar/` | linked there |
| `ghostty/config` | Ghostty | copied to `~/.config/ghostty/` | linked there |
| `herdr/config.toml` | herdr for macOS | copied to `~/.config/herdr/` | first half of the generated config |
| `herdr/space-colors/` | work-only plugin and `sidebar.toml` | — | plugin linked, `sidebar.toml` appended to the config |

## windows/ (win-ricing)

Only two files are read from here by this repo: `herdr/config.toml` (copied to `~/.config/herdr/config.toml` on NixOS) and `herdr/herdr-nav` (copied to `~/.local/bin/herdr-nav` on NixOS). Everything else is applied on the Windows host by hand; see its README.

## Outside git, on purpose

| File | Holds |
|---|---|
| `~/.zshrc.local` | per-machine environment, `NO_HERDR`, `PSQL_PAGER` |
| `~/.gitconfig` | user name and email on the Mac without Nix |
| `~/.ssh/config` | on the Mac without Nix |
| `~/.pg_service.conf`, `~/.pgpass` | database connections and passwords for pgf |
| `~/.config/pgf/` | own pgf queries and connection files |
