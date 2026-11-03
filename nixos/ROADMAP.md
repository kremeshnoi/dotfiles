# NixOS roadmap

Things not set up yet.

## 1. nix-darwin

- Add a `darwinConfigurations` output to `flake.nix` and import `home/` there, so macOS gets the same zsh, git, ssh, neovim, fzf and zoxide setup.
- Once it runs, drop `shared/zsh/.zshrc`, `shared/shell/env.sh` and their links in `install.sh`, together with the Homebrew path probing. `shared/zsh/ohmyzsh/` stays, `home/zsh.nix` sources it.
- Copy `~/.config/sops/age/keys.txt` to the Mac so it can decrypt `secrets/secrets.yaml`.

## 2. Docker Desktop on Windows

- The NixOS engine is the only one in use: uninstall Docker Desktop and remove the `7-docker` GlazeWM workspace from `win-ricing`.
