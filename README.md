# Dotfiles

Configs for NixOS under WSL, a Mac with nix-darwin, a Mac without Nix and the Windows host. Every system runs a tiling WM, the same shell, Helix and herdr, and the keybinding letters are kept the same across all of them wherever the platform allows it.

```
nix/       NixOS-WSL and nix-darwin with one home-manager setup, built from nix/flake.nix
shared/    configs that work on any OS: zsh, git, Helix, herdr, Claude skills
mac/       submodule → mac-ricing: GlazeWM, SwiftBar, Ghostty, herdr for macOS, and install.sh for a Mac without Nix
windows/   submodule → win-ricing: the Windows rice
docs/      how it works, rules, decisions
```

## Install

```bash
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git ~/dev/dotfiles
```

| Machine | Command |
|---|---|
| NixOS under WSL | `sudo nixos-rebuild switch --flake ~/dev/dotfiles/nix#nixos` |
| Mac with Nix | `sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dev/dotfiles/nix#mac` |
| Mac without Nix | `~/dev/dotfiles/mac/install.sh` |
| Windows | see [win-ricing](https://github.com/kremeshnoi/win-ricing) |

After the first switch, `nh os switch` and `nh darwin switch` rebuild from the repo. Details per machine are in [docs/machines.md](docs/machines.md).

## Docs

- [For agents](docs/agents.md) — start here to set up, update or extend the dotfiles with an AI agent
- [Architecture](docs/architecture.md) — which machine takes what, how a file reaches `$HOME`
- [Rules](docs/rules.md) — where a new file goes and how to add things
- [Keybindings](docs/keybindings.md) — GlazeWM and herdr across macOS and Windows
- [Shell](docs/shell.md), [Helix](docs/helix.md), [herdr](docs/herdr.md), [NixOS](docs/nixos.md), [Claude Code](docs/claude-code.md)
- [Decisions](docs/adr/README.md) and the [roadmap](docs/roadmap.md)

## License

[Unlicense](LICENSE)
