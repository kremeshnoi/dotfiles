# Verification

Run the checks that match the change before calling it done.

## Shell

In a new shell on any machine:

```bash
NO_HERDR=1 zsh -i -c 'whence -w gst ll c z zhm-add-update-region-highlight-hook fzf-git-local-branch-widget; echo $EDITOR $HISTSIZE; [[ -o histignoredups ]] && echo history-ok'
```

Every name has to resolve, `EDITOR` is `hx`, `HISTSIZE` is `10000`.

To try an edited `mac/zsh/.zshrc` without replacing `~/.zshrc`:

```bash
d=$(mktemp -d); ln -s ~/dev/dotfiles/mac/zsh/.zshrc "$d/.zshrc"; NO_HERDR=1 ZDOTDIR="$d" zsh -i -c 'whence -w gst c z'
```

## Mac without Nix

```bash
bash -n ~/dev/dotfiles/mac/install.sh
~/dev/dotfiles/mac/install.sh
```

The second run must print only `ok` lines besides `brew bundle` output. Then:

```bash
herdr --version
herdr plugin list
diff <(cat ~/dev/dotfiles/mac/herdr/config.toml ~/dev/dotfiles/mac/herdr/space-colors/sidebar.toml) ~/.config/herdr/config.toml
pgf services
git config --get diff.algorithm
```

herdr matches `shared/herdr/versions.toml`; the plugin list shows reviewr at `v<version>`, workspace-tabs and space-colors from the checkout; the diff is empty; pgf lists the connections; git prints `histogram`.

Links: run the check in [links.md § Checking them](links.md#checking-them); every line must be `ok`.

herdr configs: `herdr config check` validates the active one, `HERDR_CONFIG_PATH=windows/herdr/config.toml herdr config check` the NixOS one; `herdr server reload-config` applies a change without restarting herdr and prints its diagnostics.

## Packages

```bash
python3 .github/scripts/packages.py
```

It compares the package lists of the three machines, with the Nix and Homebrew names mapped and the exceptions listed in the script, and fails on any gap. CI runs it on every push.

## Nix

On a machine with Nix, from `~/dev/dotfiles`:

```bash
nix flake check ./nix
nix eval --raw ./nix#nixosConfigurations.nixos.config.system.build.toplevel.drvPath
nix eval --raw ./nix#darwinConfigurations.mac.config.system.build.toplevel.drvPath
```

Both commands print a store path when the system evaluates. On the machine itself, `nh os build` or `nh darwin build` builds without switching.

New files must be `git add`ed first: a flake only sees tracked files.

To read a generated file:

```bash
nix eval --raw ./nix#darwinConfigurations.mac.config.home-manager.users.kremeshnoi.home.file --apply 'f: f."./.zshrc".text'
nix eval --raw ./nix#nixosConfigurations.nixos.config.home-manager.users.kremeshnoi.xdg.configFile --apply 'f: f."git/config".text'
```

## Nix without Nix

On the Mac without Nix, evaluate in a container. colima mounts only `$HOME`, so the copy goes there:

```bash
colima start
w=$HOME/.cache/dotfiles-check; rm -rf "$w"; mkdir -p "$w"; rsync -a ~/dev/dotfiles/ "$w/"
docker run --rm -v "$w":/w nixos/nix:2.28.3 sh -c '
  export NIX_CONFIG="experimental-features = nix-command flakes"
  git config --global --add safe.directory "*"
  cd /w
  nix eval --raw ./nix#nixosConfigurations.nixos.config.system.build.toplevel.drvPath; echo
  nix eval --raw ./nix#darwinConfigurations.mac.config.system.build.toplevel.drvPath; echo
  nix flake check ./nix'
rm -rf "$w"; docker rmi nixos/nix:2.28.3; colima stop
```

Both `drvPath`s printing a store path means both systems evaluate. The container is aarch64, so `nix flake check` skips the x86_64-linux checks; CI covers them. Stop colima and remove the image afterwards if they were not running before.

## Scripts

```bash
shellcheck mac/install.sh shared/herdr/*.sh shared/herdr/workspace-tabs/*.sh
```

Without shellcheck installed: `nix shell nixpkgs#shellcheck -c shellcheck …` inside the container above.

## CI

After a push:

```bash
gh run list -R kremeshnoi/dotfiles -L 1
gh run watch <id> -R kremeshnoi/dotfiles --exit-status
```

## Docs

Every relative link in `README.md` and `docs/` has to resolve:

```bash
python3 - <<'EOF'
import re, pathlib
for f in [pathlib.Path('README.md'), *pathlib.Path('docs').rglob('*.md')]:
    for m in re.finditer(r'\]\(([^)#]+)(#[^)]*)?\)', f.read_text()):
        t = m.group(1)
        if not t.startswith('http') and not (f.parent / t).exists():
            print(f, t)
EOF
```
