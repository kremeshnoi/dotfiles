# NixOS Config

Declarative NixOS + home-manager flake for `alex-nixos` (i9-13900k / RTX 4090).

## Layout

- `flake.nix` — inputs (`nixpkgs` unstable, `home-manager`, `caelestia-shell`) and the `alex-nixos` system
- `configuration.nix` — system: boot, networking, locale, users, audio, Hyprland, Steam, 1Password, greetd, fonts, NVIDIA
- `home.nix` — user (`alex`): Hyprland keybinds/decorations, packages (dev toolchains, GUI apps), zsh, git, foot, Caelestia shell
- `hardware-configuration.nix` — generated, host-specific

## Apply

```sh
sudo nixos-rebuild switch --flake ~/dev/nixos-config#alex-nixos
```

The `rebuild` zsh alias wraps the same command.

## Shell

This config enables `zsh` system-wide and installs `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`, `zoxide`. The actual `~/.zshrc` is owned by [`zsh-config`](https://github.com/kremeshnoi/zsh-config) — clone it and run `./install.sh` to symlink it. The two repos are designed to compose: this one provides the packages, `zsh-config` provides the rc.

## Adding things

- User-level packages / programs → `home.nix` (`home.packages` or `programs.*`)
- System services / kernel / hardware → `configuration.nix`
- Search names at <https://search.nixos.org>
- Don't install via `npm -g` / `pip` / `cargo install` — add it here instead
