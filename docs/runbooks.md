# Runbooks

Each procedure lists the files to touch, the exact snippet and the check. Paths are relative to `~/dev/dotfiles`.

## Setting up

### Clone

```bash
mkdir -p ~/dev
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git ~/dev/dotfiles
```

Without an SSH key for GitHub, clone over https and point the submodules at https for this checkout:

```bash
git -c url."https://github.com/".insteadOf="git@github.com:" clone --recurse-submodules https://github.com/kremeshnoi/dotfiles.git ~/dev/dotfiles
```

An old checkout at `~/dev/dotfiles/dotfiles` moves once: `mv ~/dev/dotfiles/dotfiles ~/dev/dotfiles.tmp && rmdir ~/dev/dotfiles && mv ~/dev/dotfiles.tmp ~/dev/dotfiles` — only when `~/dev/dotfiles` holds nothing else.

### Set up NixOS under WSL

1. NixOS-WSL installed with `wsl.defaultUser = "kremeshnoi"`.
2. Clone.
3. `sudo nixos-rebuild switch --flake ~/dev/dotfiles/nix#nixos`
4. `ssh-add ~/.ssh/id_ed25519`
5. Open a new terminal; run the checks in [verification.md § shell](verification.md#shell).

Later switches: `nh os switch`.

### Set up a Mac with Nix

Only with the user's go-ahead, and only for the user `kremeshnoi`.

1. Homebrew from [brew.sh](https://brew.sh).
2. Nix from the official installer: `sh <(curl -L https://nixos.org/nix/install)`, then a new terminal.
3. Clone.
4. First switch:
   ```bash
   sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dev/dotfiles/nix#mac
   ```
   If it refuses to touch `/etc/zshrc` or `/etc/bashrc`, rename them to `*.before-nix-darwin` as it says and run it again.
5. Grant GlazeWM Accessibility access (System Settings → Privacy & Security → Accessibility).
6. `exec zsh`; run [verification.md § shell](verification.md#shell).

Later switches: `nh darwin switch`.

### Set up a Mac without Nix

1. Homebrew from [brew.sh](https://brew.sh); `git` comes with the Xcode command line tools.
2. Clone.
3. `~/dev/dotfiles/mac/install.sh`
4. `exec zsh`
5. Grant GlazeWM Accessibility access.
6. Put the user's name and email into `~/.gitconfig` if missing.
7. Run [verification.md § Mac without Nix](verification.md#mac-without-nix).

### Another user name

The Nix side hardcodes `kremeshnoi` in `nix/flake.nix` (`users.kremeshnoi`), `nix/home/default.nix` (`home.username`, `home.homeDirectory`), `nix/darwin/configuration.nix` (`system.primaryUser`, `users.users`, `NH_FLAKE`, SwiftBar plugin dir) and `nix/nixos/configuration.nix` (`wsl.defaultUser`, `users.users`, `programs.nh.flake`, the `ConditionUser` of a unit). Supporting another user means turning these into one parameter passed through `specialArgs` and `extraSpecialArgs`; agree on it with the user first. `mac/install.sh` works for any user as is.

## Updating

| Machine | Steps |
|---|---|
| any | `git -C ~/dev/dotfiles pull && git -C ~/dev/dotfiles submodule update --init` |
| NixOS | `nh os switch` |
| Mac with Nix | `nh darwin switch` |
| Mac without Nix | `~/dev/dotfiles/mac/install.sh`, then `exec zsh` |

Nix inputs: merge the weekly `update-flake-lock` PR, or run `nix flake update` in `nix/` and switch. One input: `nix flake update pgf`.

## Changing

### Add a CLI tool

1. Nix: add the nixpkgs attribute to `environment.systemPackages` in `nix/darwin/configuration.nix` and `nix/nixos/configuration.nix`, or to `home.packages` in `nix/home/default.nix` when it is user tooling.
2. Mac without Nix: `brew "<formula>"` in `mac/Brewfile`; a GUI app is `cask "<name>"`. Check the name with `brew info <formula>`.
3. Check: `python3 .github/scripts/packages.py` must print `package lists in sync`; then [verification.md § Nix](verification.md#nix) and `brew bundle --file mac/Brewfile`. A tool meant for NixOS only goes into `nixos_only` in that script, so the choice is explicit.

### Add a language server

1. `nix/home/helix.nix`: add the package to `languageServers`.
2. `mac/Brewfile`: add the formula. When nixpkgs has none, package the release binary in `nix/pkgs/` the way `phpantom.nix` does; when Homebrew has none, install it from `install.sh` into its own directory and add that directory to the front of `PATH` in `mac/helix/hx`.
3. `shared/helix/languages.toml`: only if Helix has no default server for the language.
4. Add the row to the table in [helix.md](helix.md).

### Add a config file for a tool on every OS

1. Put it under `shared/<tool>/`.
2. Nix: a module `nix/home/<tool>.nix`, imported in `nix/home/default.nix`:
   ```nix
   {
     xdg.configFile."<tool>/<file>".source = ../../shared/<tool>/<file>;
   }
   ```
   For a whole directory: `xdg.configFile."<tool>".source = ../../shared/<tool>;`. For a file in `$HOME`: `home.file."<path>".source = …;`.
3. Mac without Nix, in `mac/install.sh` next to the other `link` lines:
   ```bash
   link "$shared/<tool>/<file>" "$HOME/.config/<tool>/<file>"
   ```
4. Install the tool on both sides ([Add a CLI tool](#add-a-cli-tool)).
5. Add the file to [inventory.md](inventory.md).

### Add a macOS-only config file

1. Put it in `mac/<tool>/` (the mac-ricing repo).
2. Nix: in `nix/home/darwin.nix`, `xdg.configFile."<tool>/<file>".source = ../../mac/<tool>/<file>;`.
3. `mac/install.sh`: `link "$mac/<tool>/<file>" "$HOME/.config/<tool>/<file>"`.
4. Commit in `mac/` first, then the bump here.

### Change the shell

| Change | File |
|---|---|
| alias, option, widget, prompt, history | `shared/zsh/rc.zsh` |
| environment variable, PATH entry | `shared/zsh/env.zsh` |
| something that must run before everything else | `shared/zsh/startup.zsh` |
| macOS-only PATH (Homebrew kegs) | `mac/zsh/.zshrc` |
| Linux-only variable | `home.sessionVariables` in `nix/home/default.nix` |
| a plugin | `plugins` in `nix/home/zsh.nix` **and** a `source` line plus the Brewfile formula in `mac/zsh/.zshrc` |

### Change git settings

`shared/git/config`. The user and email stay in `nix/home/git.nix` and in `~/.gitconfig` on the Mac without Nix.

### Bump herdr or reviewr

1. `shared/herdr/versions.toml`: new version.
2. Hashes for every platform:
   ```bash
   v=0.9.6
   for a in herdr-linux-x86_64 herdr-macos-aarch64; do nix store prefetch-file --json "https://github.com/herdrdev/herdr/releases/download/v$v/$a" | jq -r .hash; done
   ```
   Put them into `assets` in `nix/pkgs/herdr.nix`. For reviewr the same with `herdr-reviewr-x86_64-unknown-linux-musl.tar.gz`, `herdr-reviewr-aarch64-apple-darwin.tar.gz` and `https://raw.githubusercontent.com/persiyanov/herdr-reviewr/v$v/herdr-plugin.toml` into `nix/home/herdr.nix`. Without Nix, run the command in the container from [verification.md § Nix without Nix](verification.md#nix-without-nix).
3. Mac without Nix: `brew unpin herdr && brew upgrade herdr && brew pin herdr`, then `install.sh` (it reinstalls reviewr at the new tag).
4. Check the herdr config still loads: `herdr` starts without a config warning.

### Add a herdr plugin

1. Local plugin, any OS: `shared/herdr/<name>/` with `herdr-plugin.toml`.
2. Nix: add `{ id = "<id>"; root = "${../../shared/herdr/<name>}"; }` to `plugins` in `nix/home/herdr.nix`.
3. `mac/install.sh`: add `"$shared/herdr/<name>"` to the `for root in …` list of local plugins.
4. A third-party plugin from GitHub follows reviewr: release asset in Nix, `herdr plugin install --ref` in `install.sh`, version in `shared/herdr/versions.toml`.

### Add a Claude Code skill

Create `shared/claude/skills/<name>/SKILL.md`. Nothing else: both sides pick up every folder. Never name a docs file `claude.md` on macOS ([troubleshooting.md](troubleshooting.md#a-docs-page-is-read-as-instructions)).

### Change a keybinding

1. macOS: `mac/glazewm/config.yaml` or `mac/herdr/config.toml`.
2. Windows: the matching file in `windows/` (and `windows/glazewm/index.ahk` for herdr jumps).
3. Keep the letter the same on both, update [keybindings.md](keybindings.md).

### Record a decision

Copy the template from [adr/README.md](adr/README.md) to `docs/adr/NNNN-<slug>.md`, add it to the index, and mark the record it replaces as superseded.

## Committing

1. In `mac/` or `windows/`: commit, push.
2. Here: commit the changes and the submodule bump, push.
3. Watch CI: `gh run list -R kremeshnoi/dotfiles -L 1`.

Conventional Commits; a layout change carries `!` and a `BREAKING CHANGE:` footer with what to do on a machine. Commit only when the user asks.
