# NixOS roadmap

Things not set up yet.

## 1. nix-darwin

- `darwinConfigurations.mac` is in the flake but has not been switched on the Mac yet: run the first switch from the README and fix what breaks.
- Copy `~/.config/sops/age/keys.txt` to the Mac so it can decrypt `secrets/secrets.yaml`.

## 2. Docker Desktop on Windows

- The NixOS engine is the only one in use: uninstall Docker Desktop and remove the `7-docker` GlazeWM workspace from `win-ricing`.
