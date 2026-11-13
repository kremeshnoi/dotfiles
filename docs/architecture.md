# Architecture

## Four parts

```
nix/      wiring for the machines with Nix: NixOS under WSL and the Mac at home
shared/   configs that work on any OS
mac/      submodule → mac-ricing: macOS-only configs and the setup for a Mac without Nix
windows/  submodule → win-ricing: the Windows rice
```

Each part has one job:

- `shared/` holds settings: zsh, git, Helix, herdr scripts and plugins, Claude skills. Nothing in it knows which OS it runs on.
- `mac/` and `windows/` hold settings that only make sense on one OS: the window manager, the menu bar, the terminal, the herdr keybindings of that OS. Every machine on that OS takes them from the same place.
- `nix/` holds no settings of its own beyond packages and system options. It takes files from `shared/`, `mac/` and `windows/` and puts them where they belong.
- `mac/install.sh` does the same job as `nix/` for a Mac where Nix is not allowed.

See [ADR 0003](adr/0003-os-specific-rice-in-submodules.md), [0004](adr/0004-shared-holds-os-independent-configs.md) and [0009](adr/0009-everything-nix-under-nix.md).

## Machines

| Machine | Built by | Takes from |
|---|---|---|
| NixOS under WSL | `nix/flake.nix#nixos` | `nix/`, `shared/`, `windows/` (herdr config, `herdr-nav`) |
| Mac at home | `nix/flake.nix#mac` (nix-darwin) | `nix/`, `shared/`, `mac/` |
| Mac at work, no Nix | `mac/install.sh` | `shared/`, `mac/` |
| Windows host | by hand, see win-ricing | `windows/` |

Both Nix systems share one home-manager configuration in `nix/home/`; the few differences are guarded by `isDarwin`.

## How a file reaches `$HOME`

**With Nix.** home-manager builds every managed file into the store, and `nix/home/copy-files.nix` copies it into `$HOME` instead of linking it ([ADR 0002](adr/0002-copy-home-files-instead-of-symlinking.md)). A repo edit takes effect after the next switch. The flake sets `self.submodules`, so files in `mac/` and `windows/` are part of the build.

**Without Nix.** `mac/install.sh` links each file from the checkout into `$HOME`, so a repo edit takes effect at once ([ADR 0005](adr/0005-mac-without-nix.md)). One file is not a link: `~/.config/herdr/config.toml` is generated from `mac/herdr/config.toml` and `mac/herdr/space-colors/sidebar.toml`, since herdr reads a single file ([ADR 0010](adr/0010-work-only-herdr-sidebar.md)).

A file in the way is moved aside: `<name>.hm-backup` with Nix, `<name>.backup-<timestamp>` with `install.sh`.

## The shell, as an example

```
shared/zsh/env.zsh      ← sourced from .zshenv by home-manager, from .zshrc by mac/zsh/.zshrc
shared/zsh/startup.zsh  ← sourced early by both
shared/zsh/rc.zsh       ← sourced in the middle by both
```

home-manager and `mac/zsh/.zshrc` only add what differs: where the plugins come from (Nix store or Homebrew), `compinit`, syntax highlighting. See [shell.md](shell.md).

## Versions

- Nix inputs are pinned in `nix/flake.lock` and updated weekly by CI.
- herdr and reviewr are pinned in `shared/herdr/versions.toml` for every machine ([ADR 0006](adr/0006-pin-herdr-and-reviewr.md)).
- Homebrew packages on the Mac without Nix follow Homebrew, except herdr, which is pinned there.
- Runtimes come from version managers that read the project's own files ([ADR 0007](adr/0007-editor-tooling-vs-runtimes.md)).

## CI

`.github/workflows/flake-check.yml` runs `.github/scripts/packages.py`, which fails when the package lists of the machines drift apart, and `nix flake check ./nix` on every push. `update-flake-lock.yml` runs `nix flake update` every Monday, checks the result and opens a pull request. Both rewrite the GitHub ssh URLs to https, since the runner has no SSH key and the submodules are public.
