# Roadmap

Things not set up yet.

## 1. nix-darwin on the Mac at home

- `darwinConfigurations.mac` builds in CI but has not been switched on the Mac yet: run the first switch from [machines.md](machines.md) and fix what breaks.
- Move the checkout from `~/dev/dotfiles/dotfiles` to `~/dev/dotfiles` first.
- Copy `~/.config/sops/age/keys.txt` to the Mac so it can decrypt `shared/secrets/secrets.yaml`.

## 2. Docker Desktop on Windows

- The NixOS engine is the only one in use: uninstall Docker Desktop and remove the `7-docker` GlazeWM workspace from `win-ricing`.
