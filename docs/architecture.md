# Architecture

## Four parts

```
shared/   settings that work on any OS
nix/      submodule → nix-config: the two machines with Nix, NixOS under WSL and the Mac at home
mac/      submodule → mac-ricing: the work Mac, set up without Nix
windows/  submodule → win-ricing: the Windows host
```

- `shared/` holds settings: zsh, git, Helix, lazygit, lazydocker, the bat theme, the herdr base config and plugins, Claude skills. Nothing in it knows which machine it runs on, except the two herdr key files, which are named after the OS they serve.
- `nix/` is the Nix machines' own repo. It places files from `shared/`, which it takes from its `dotfiles` flake input, and from its own platform modules, and declares packages and system options.
- `mac/` is the work Mac's own repo: its Brewfile, `install.sh` and the configs only that Mac uses.
- `windows/` is the Windows host's own repo, applied there by hand. Nothing in it is read by a Nix machine.

See [ADR 0003](adr/0003-os-specific-rice-in-submodules.md), [0004](adr/0004-shared-holds-os-independent-configs.md), [0009](adr/0009-everything-nix-under-nix.md) and [0019](adr/0019-nix-in-its-own-repo.md).

## Machines

| Machine | Built by | Takes from |
|---|---|---|
| NixOS under WSL | `nix/flake.nix#nixos` | `shared/`, `nix/home`, `nix/home/nixos`, `nix/nixos` |
| Mac at home | `nix/flake.nix#mac` (nix-darwin) | `shared/`, `nix/home`, `nix/home/darwin`, `nix/darwin` |
| Mac at work, no Nix | `mac/install.sh` | `shared/`, `mac/` |
| Windows host | by hand, see win-ricing | `windows/` |

`flake.nix` gives each Nix machine `nix/home` plus its own platform module. The shared modules carry no platform conditions; a value that differs is set by the platform module, for example `dotfiles.herdrKeys`.

## How a file reaches `$HOME`

Every machine gets real files, never links into the repo or the store.

- **With Nix.** home-manager builds every file into the store and `nix/home/copy-files.nix` copies it into `$HOME` ([ADR 0002](adr/0002-copy-home-files-instead-of-symlinking.md)). An edit applies after the next switch.
- **Without Nix.** `mac/install.sh` copies each file from the checkout and records it in `~/.local/state/dotfiles/copied` ([ADR 0016](adr/0016-mac-without-nix-copies-files.md)). An edit applies after the next run.

A file in the way that neither of them placed is moved aside: `<name>.hm-backup` with Nix, `<name>.backup-<timestamp>` with `install.sh`. A file they placed before is overwritten.

## Generated files

herdr reads one file, so its config is glued together on every machine ([ADR 0017](adr/0017-herdr-config-from-base-and-keys.md)):

```
shared/herdr/base.toml           theme, sound, UI — the same everywhere
+ shared/herdr/keys-windows.toml  NixOS: the lwin jumps are left to AutoHotkey
  or shared/herdr/keys-macos.toml both Macs: alt as the modifier
+ space-colors sidebar            shared/herdr/space-colors on Nix, mac/herdr/space-colors at work
```

On the work Mac `~/.zshrc` is generated too: a first line with the path to `shared/`, then `mac/zsh/.zshrc`.

## Packages

One list per scope ([ADR 0018](adr/0018-user-tools-in-home-packages.md)):

| List | Holds |
|---|---|
| `nix/home/default.nix` `home.packages` | every tool both Nix machines use |
| `nix/home/nixos/default.nix` `home.packages` | tools only NixOS uses: compilers, runtimes, Docker clients |
| `nix/home/darwin/default.nix` `home.packages` | tools only the Mac with Nix uses |
| `nix/nixos`, `nix/darwin` `systemPackages` | only what the system itself calls by path: herdr, `hx-open-tab`, nh |
| `mac/Brewfile` | the work Mac; must match the shared list and the darwin list |

`.github/scripts/packages.py` compares the Brewfile with the Mac with Nix and fails on any gap.

## The shell, as an example

```
shared/zsh/env.zsh      ← sourced from .zshenv by home-manager, from .zshrc by mac/zsh/.zshrc
shared/zsh/startup.zsh  ← sourced early by both
shared/zsh/rc.zsh       ← sourced in the middle by both
```

home-manager and `mac/zsh/.zshrc` only add what differs: where the plugins come from, `compinit`, syntax highlighting. See [shell.md](shell.md).

## NixOS under WSL

`nix/nixos/configuration.nix` holds the system: Docker, nix-ld for prebuilt binaries, the ssh-agent and `herdr-navd` user units.

- Channels are disabled; `nixos-rebuild switch --rollback` or a git revert undoes a change.
- The store is garbage-collected weekly and optimised by systemd timers.
- `, <program>` runs anything from nixpkgs without installing it.
- An activation script puts a wrapper for every system binary into `/usr/local/bin`, plus `/bin/bash`, so `#!/usr/bin/env` scripts and `wsl.exe -e <cmd>` from Windows find their tools.
- `herdr-navd` runs `herdr-nav serve` on `127.0.0.1:47391`. AutoHotkey on Windows sends `tab next` and friends over that socket, about 0.5 ms per key instead of ~120 ms for spawning `wsl.exe`.
- Opening a text file from Explorer lands in Helix: `windows/terminal/install-helix-open.ps1` points the extensions at `helix-open.vbs`, which focuses Optimum and runs `hx-open-tab`, which opens a herdr tab rooted at the file's git repository.

## Claude Code

`shared/claude/skills/<name>` becomes `~/.claude/skills/<name>` on every machine. Only the skills are shared; `CLAUDE.md`, settings, history and credentials stay local. `c` is an alias for `claude --dangerously-skip-permissions`.

## Versions

- Nix inputs are pinned in `nix/flake.lock` and updated weekly by CI.
- herdr is pinned in `shared/herdr/versions.toml` for every machine ([ADR 0006](adr/0006-pin-herdr.md)).
- Homebrew on the work Mac follows Homebrew, except herdr, which is pinned there.
- Runtimes come from version managers that read the project's own files ([ADR 0007](adr/0007-editor-tooling-vs-runtimes.md)).

## CI

`.github/workflows/flake-check.yml` runs `.github/scripts/packages.py` and `nix flake check ./nix` against this checkout's `shared/` on every push. In nix-config, `flake-check.yml` runs `nix flake check` on every push and `update-flake-lock.yml` runs `nix flake update` every Monday and opens a pull request.
