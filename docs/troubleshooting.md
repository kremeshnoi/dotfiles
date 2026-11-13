# Troubleshooting

Failures already met, with the cause and the fix.

## macOS

### A downloaded binary dies with `Killed: 9`

On the work Mac a release binary downloaded with curl into `$HOME` is killed with SIGKILL (exit 137), although `codesign -v` says it is valid and the same bytes run from `/tmp`. Install the tool from Homebrew instead; that is why herdr comes from Homebrew there ([ADR 0006](adr/0006-pin-herdr-and-reviewr.md)).

### GlazeWM cannot find a script

GlazeWM runs `shell-exec` commands from `/` and does not expand `~` or `$HOME` in arguments. Go through bash: `shell-exec /bin/bash -c $HOME/.glzr/glazewm/kill-workspace.sh`. The environment does carry `HOME`.

### `brew uninstall` removed something else

`brew uninstall` also removes dependencies nothing needs any more. Check with `brew uses --installed <formula>` before uninstalling, and list what went with `brew list --versions` afterwards.

### `brew bundle` fails on a font, and `install.sh` stops

`It seems the existing Font is different from the one being installed` means the font files are already in `~/Library/Fonts`, copied there by hand. `brew install --cask --force <font cask>` puts the cask's copy over them; then rerun `install.sh`. The script runs with `set -e`, so any failed step stops everything after it: check the exit code.

### `psql` not found

Homebrew's `libpq` is keg-only. `mac/zsh/.zshrc` adds `/opt/homebrew/opt/libpq/bin` to PATH, and pgf finds it by itself.

### A docs page is read as instructions

The macOS file system is case-insensitive, so `docs/claude.md` is the same file as `docs/CLAUDE.md`, which Claude Code loads as instructions for that directory. The Claude Code page is `docs/claude-code.md` for that reason.

### `herdr` stays at an old version

It is pinned with `brew pin`, so `brew upgrade` skips it. Unpin, upgrade, pin again, and bump `shared/herdr/versions.toml` with the Nix hashes.

## herdr

### The sidebar shows no workspace names

`[ui.sidebar.spaces]` in `mac/herdr/space-colors/sidebar.toml` shows the space-colors tokens instead of the name. The section only works together with that plugin, which is why it is appended by `install.sh` on the work Mac only ([ADR 0010](adr/0010-work-only-herdr-sidebar.md)).

### An edit to the herdr config does nothing

On the work Mac `~/.config/herdr/config.toml` is generated: rerun `install.sh`. herdr reads one file; there is no include, only `HERDR_CONFIG_PATH`.

## Nix

### The flake does not see a new file

A flake only sees files git tracks. `git add` the file; a commit is not needed.

### `Existing file … would be clobbered`

A file home-manager never wrote is in the way and `<name>.hm-backup` already exists. Look at both, keep what matters in the repo, delete the old backup, switch again.

### The first nix-darwin switch refuses `/etc/zshrc` or `/etc/bashrc`

Rename them to `*.before-nix-darwin` as the message says and switch again.

### A setting in `rc.zsh` is overridden, or one from home-manager wins

home-manager writes its parts of `.zshrc` by order: `startup.zsh` at 510, `compinit` at 570, history at 910, `rc.zsh` at 1000, syntax highlighting at 1200, `mkAfter` at 1500. Settings in `rc.zsh` override history at 910. `ZSH_HIGHLIGHT_STYLES` must be set before syntax highlighting is sourced, which `rc.zsh` does.

### A symlink from `mkOutOfStoreSymlink` turned into a copy

`nix/home/copy-files.nix` copies with `cp -RL`, which follows links ([ADR 0002](adr/0002-copy-home-files-instead-of-symlinking.md)).

### `path:` flake cannot find `../../shared`

A `path:` flake reference copies only the flake directory. Use the git checkout (`./nix` inside the repo), which copies the whole repo with the submodules.

## CI

### `Failed to fetch git repository 'ssh://git@github.com/…'`

The runner has no SSH key. Both workflows rewrite `ssh://git@github.com/` and `git@github.com:` to https before `nix`. A new workflow needs the same step, and a new submodule has to be public.

## git

### A commit carries the work email

On the work Mac the global git email is the work one, while these repos are committed with the personal one. Commit with `GIT_AUTHOR_EMAIL=alexander.kremeshnoi@gmail.com GIT_COMMITTER_EMAIL=alexander.kremeshnoi@gmail.com` there, or set it per repo with `git config user.email`.
