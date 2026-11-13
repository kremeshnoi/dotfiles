# Machines

Every machine keeps the repo at `~/dev/dotfiles`, cloned with its submodules:

```bash
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git ~/dev/dotfiles
git submodule update --init   # if already cloned
```

## Mac with Nix

nix-darwin builds `darwinConfigurations.mac` (Apple Silicon). Nix comes from the [official installer](https://nixos.org/download/), Homebrew from [brew.sh](https://brew.sh); nix-darwin drives Homebrew for the casks — GlazeWM, SwiftBar, Ghostty — and leaves anything else installed alone (`onActivation.cleanup = "none"`).

```bash
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dev/dotfiles/nix#mac
```

After that `nh darwin switch` rebuilds from the repo (`NH_FLAKE` points to `~/dev/dotfiles/nix`). The first switch moves an existing `~/.zshrc` and the rest out of the way as `<name>.hm-backup`. The age key has to be in `~/.config/sops/age/keys.txt` before the first switch, see [secrets.md](secrets.md).

GlazeWM needs Accessibility access (System Settings → Privacy & Security → Accessibility).

## Mac without Nix

```bash
~/dev/dotfiles/mac/install.sh
exec zsh
```

`install.sh` runs `brew bundle` on `mac/Brewfile`, links the configs from `shared/` and `mac/`, generates the herdr config, installs the herdr plugins at the pinned versions, clones pgf into `~/.local/src/pgf` and, with an age key present, decrypts the secrets. It is safe to run again; run it after editing a generated file or bumping a version. Details are in the [mac-ricing README](https://github.com/kremeshnoi/mac-ricing).

## NixOS under WSL

```bash
sudo nixos-rebuild switch --flake ~/dev/dotfiles/nix#nixos
ssh-add ~/.ssh/id_ed25519
```

After that `nh os switch` rebuilds from the repo, showing the build tree and a package diff between generations. See [nixos.md](nixos.md).

## Windows host

Set up by hand from [win-ricing](https://github.com/kremeshnoi/win-ricing), mounted here as `windows/`.

## Updating

| What | How |
|---|---|
| Nix inputs | merge the weekly `update-flake-lock` pull request, or `nix flake update` in `nix/`, then switch |
| Homebrew on the Mac without Nix | `brew upgrade`; herdr stays pinned |
| herdr, reviewr | bump `shared/herdr/versions.toml` and the hashes, switch or rerun `install.sh` |
| pgf | `nix flake update pgf` in `nix/`; `install.sh` pulls `~/.local/src/pgf` |
| a submodule | commit and push inside it, then commit the bump here |

## Undoing a change

`nixos-rebuild switch --rollback`, `darwin-rebuild switch --rollback`, or a git revert followed by a switch. On the Mac without Nix a git revert applies at once for linked files; rerun `install.sh` for generated ones.
