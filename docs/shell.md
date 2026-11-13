# Shell

## zsh

The shell lives in `shared/zsh` and is the same everywhere:

| File | Sourced | Holds |
|---|---|---|
| `env.zsh` | from `.zshenv` with Nix, at the top of `.zshrc` without | `EDITOR` and `VISUAL` (`hx`), `LESS`, deno and fnm roots, fzf defaults, PATH |
| `startup.zsh` | early in `.zshrc` | fnm init, `~/.zshrc.local`, the herdr autostart |
| `rc.zsh` | after the plugins | history, aliases, completion styles, prompt, the Oh My Zsh git plugin, the fzf branch widgets, highlight colours |

`nix/home/zsh.nix` adds `compinit`, the you-should-use and zsh-helix-mode plugins and syntax highlighting around them. `mac/zsh/.zshrc` does the same with Homebrew, and adds `brew shellenv` and the keg-only `libpq` to PATH.

Order matters in two places:

- home-manager sets its default history options before `rc.zsh`, so the history settings in `rc.zsh` win.
- `ZSH_HIGHLIGHT_STYLES` is filled in `rc.zsh`, before zsh-syntax-highlighting is sourced, which keeps the preset values.

Anything machine-specific goes into `~/.zshrc.local`, sourced from `startup.zsh` before the herdr autostart, so `NO_HERDR=1` can be set per machine.

The herdr autostart runs `herdr && exit` in interactive shells, except inside herdr itself, over SSH and in the VS Code terminal.

### Plugins

- Git aliases come from the Oh My Zsh `git` plugin, vendored with its `lib/git.zsh` dependency and MIT licence under `shared/zsh/ohmyzsh/`, so no Oh My Zsh install is needed. It is sourced after `compinit` because it registers completions.
- The command line uses Helix keybindings from [zsh-helix-mode](https://github.com/Multirious/zsh-helix-mode), vendored with its MIT licence under `shared/zsh/zsh-helix-mode/` at commit `e8d4940`. It replaces the keymap zsh would otherwise pick from `EDITOR`. It is sourced before syntax highlighting, and `zhm-add-update-region-highlight-hook` runs after it so the selection stays visible. To update, copy `LICENSE`, `zsh-helix-mode.zsh` and `zsh-helix-mode.plugin.zsh` from a newer commit and change the hash here.
- `shared/zsh/fzf-git-branch.zsh` puts a branch picker on `ctrl+g` (local) and `ctrl+shift+g` (remote).

The prompt is bash-style with the git branch from `vcs_info`. The accent colour `#FFBAF3` is shared with the syntax highlighting.

## git

`shared/git/config` holds the settings. `nix/home/git.nix` includes it and adds the user and git-lfs; on the Mac without Nix it is linked to `~/.config/git/config`, the user stays in `~/.gitconfig`, and `install.sh` runs `git lfs install`.

## ssh

On NixOS `SSH_AUTH_SOCK` points at `$XDG_RUNTIME_DIR/ssh-agent.socket`, served by the `ssh-agent` user unit, which stops git from asking for the key passphrase on every push. `~/.ssh/config` from `nix/home/ssh.nix` carries `AddKeysToAgent yes`, so the passphrase is asked once per WSL start, and linger keeps the agent alive after the last terminal closes. The Mac without Nix keeps its own `~/.ssh/config`.

## Other tools

- **pgf** — fzf picker for psql connections and saved queries, from [kremeshnoi/pgf](https://github.com/kremeshnoi/pgf). The home-manager module installs it on the Nix machines; `install.sh` clones it and links it into `~/.local/bin`. Connections come from `~/.pg_service.conf`.
- **direnv** with nix-direnv: a project with its own `flake.nix` and an `.envrc` containing `use flake` gets its toolchain on `cd`.
- **zoxide** and **fzf** on every machine. The editor is Helix: `EDITOR`, `VISUAL` and git's `core.editor` are `hx`.

## Colours

`ls` is GNU `ls` everywhere, so it colours the same way on every machine: NixOS has it as `ls`, the Macs get it as `gls` from `coreutils-prefixed` (Nix) or `coreutils` (Homebrew), and `rc.zsh` aliases `ls` to whichever exists. The prefixed build leaves the BSD `date`, `stat` and friends in place. `LS_COLORS` comes from `shared/zsh/dir_colors`, the coreutils default database, through `dircolors` or `gdircolors`; completion lists use the same colours.
