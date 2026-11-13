# Dotfiles

Configs for two systems — macOS with nix-darwin and Windows 11 with NixOS under WSL — built from one flake with one shared home-manager setup. Every system runs a tiling WM, and the keybinding letters are kept the same across all of them wherever the platform allows it.

```
flake.nix                        NixOS-WSL + nix-darwin systems with home-manager, pinned by flake.lock
.github/workflows/               nix flake check on push, weekly flake.lock update PR
darwin/configuration.nix         nix-darwin — packages, Homebrew casks, macOS defaults
pkgs/herdr.nix                   herdr release binary for both systems
mac/                             submodule → mac-ricing, the macOS app configs and the setup for a Mac without Nix
windows/                         submodule → win-ricing, the whole Windows rice
nixos/configuration.nix          NixOS-WSL — packages, services, FHS wrappers
nixos/ROADMAP.md                 NixOS features planned but not set up yet
home/                            home-manager for both systems — zsh, git, ssh, neovim, helix, fzf, zoxide, direnv, herdr, claude, secrets
secrets/secrets.yaml             sops-encrypted wakatime and ngrok configs
.sops.yaml                       age recipients for secrets/
shared/zsh/env.zsh               environment variables and PATH, sourced from .zshenv
shared/zsh/startup.zsh           rbenv, fnm, ~/.zshrc.local and the herdr autostart, sourced early
shared/zsh/rc.zsh                aliases, prompt, completion, highlight colours, git and fzf widgets
shared/git/config                git settings without the user, included by home/git.nix
shared/zsh/ohmyzsh/              vendored Oh My Zsh git plugin — git aliases (gst, gco, gp…)
shared/zsh/zsh-helix-mode/       vendored zsh-helix-mode — Helix keybindings on the command line
shared/helix/                    Helix — editor config, LSP setup and transparent themes
shared/herdr/                    herdr — pinned herdr and reviewr versions, reviewr config, the Git Review toggle script and the workspace-tabs plugin
shared/claude/                   Claude Code skills, currently commit
```

The whole Windows side — configs and the rest of the rice — lives in [win-ricing](https://github.com/kremeshnoi/win-ricing) and is pulled in here as the `windows` submodule. The macOS app configs — GlazeWM, SwiftBar, Ghostty, herdr — live in [mac-ricing](https://github.com/kremeshnoi/mac-ricing) as the `mac` submodule; nix-darwin copies them from there, and a Mac where Nix is not allowed takes the same files through `mac/install.sh`:

```bash
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git
git submodule update --init   # if already cloned
```

Both systems take their whole home from `home/`, and nothing in `$HOME` is a symlink: every file is a real copy, see `home/copy-files.nix` below. A repo edit takes effect after `nh os switch` on NixOS and `nh darwin switch` on macOS.

## Shared mnemonics

Both systems run [GlazeWM](https://github.com/glzr-io/glazewm) with the same keybindings on the same physical keys: Ctrl and Alt are swapped in the Windows keyboard firmware, so `cmd` sits where Windows has `ctrl` and the Mac `ctrl` where Windows has `alt`. A workspace is focused with `ctrl+shift+<key>` on Windows and `cmd+shift+<key>` on macOS, `ctrl+alt+shift+<key>` / `cmd+ctrl+shift+<key>` moves the window there, a new terminal is `ctrl+enter` / `cmd+enter`, and everything else sits on `ctrl+alt` on Windows and on `cmd+ctrl` on macOS, so herdr keeps its modifier to itself — `lwin` on Windows, which is where Option sits on the Mac: `cmd+ctrl+hjkl` / `ctrl+alt+hjkl` focuses, adding `shift` moves the window, `cmd+shift+h` / `cmd+shift+l` and `ctrl+shift+h` / `ctrl+shift+l` walk the active workspaces. The workspace set is per platform.

| Workspace | macOS | Windows |
|---|---|---|
| desktop | `0` | `0` |
| system | `y` | `y` |
| term | `t` | `t` |
| edge / browser | `b` | `b` |
| claude | `a` | — |
| slack | `m` | — |
| obsidian | `n` | `n` |
| docker | `c` | `c` |
| tabularis | `d` | — |
| spotify | — | `s` |
| discord | — | `x` |
| telegram | — | `m` |
| eve | — | `e` |
| games | — | `g` |
| misc | `9` | `9` |

Both configs route windows by process name, focus follows the routed window, and everything unmatched goes to `misc` through a catch-all rule.

## macOS

[GlazeWM](https://github.com/glzr-io/glazewm) + [Ghostty](https://ghostty.org), set up by [nix-darwin](https://github.com/nix-darwin/nix-darwin) from `darwinConfigurations.mac` (Apple Silicon), with the app configs taken from the `mac` submodule. A Mac where Nix cannot be installed uses `mac/install.sh` from [mac-ricing](https://github.com/kremeshnoi/mac-ricing) instead: Homebrew for the packages and symlinks into this repo for the configs, `shared/` included. Nix itself comes from the [official installer](https://nixos.org/download/), Homebrew from [brew.sh](https://brew.sh): nix-darwin drives it for the casks — GlazeWM, SwiftBar, Ghostty — and leaves anything else installed alone. The SwiftBar plugin directory is set through `system.defaults`.

```bash
git clone --recurse-submodules git@github.com:kremeshnoi/dotfiles.git ~/dev/dotfiles
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dev/dotfiles#mac
```

After that `nh darwin switch` rebuilds from the repo. The first switch moves an existing `~/.zshrc` and the rest out of the way as `<name>.hm-backup`.

GlazeWM needs Accessibility access (System Settings → Privacy & Security → Accessibility). The `cmd+ctrl` bindings are grabbed system-wide. On macOS `window_process` matches the localized app name (`Microsoft Edge`, `System Settings`), so the rules assume an English system. macOS system apps go to `system`. `cmd+shift+q` runs `kill-workspace.sh`, which jumps to the previous workspace and quits every app on the one it left (Finder windows are only closed). The active workspace is shown in the native menu bar by a streamable SwiftBar plugin that re-renders on `glazewm sub` events; clicking it lists every workspace.

Ghostty runs `macos-option-as-alt = true`, which is what frees Alt for nvim and herdr. Splits are on `cmd+ctrl+hjkl`, creating them adds `shift`.

## Windows

See [win-ricing](https://github.com/kremeshnoi/win-ricing), mounted here as `windows/` — GlazeWM, the AutoHotkey script that kills the Start menu on a lone Win press, four Windhawk mods, herdr navigation over the socket API, Raycast, Spicetify, and removing Xbox Game Bar to free `Win+G`.

## NixOS

The Linux side under WSL is [NixOS-WSL](https://github.com/nix-community/NixOS-WSL), built from `flake.nix` at the repo root. The flake pins nixpkgs, NixOS-WSL, home-manager, sops-nix and nix-index-database in `flake.lock`; `nixos/configuration.nix` holds the system — packages, Docker, nix-ld for prebuilt binaries, the ssh-agent and `herdr-navd` user units — and `home/` holds the user side through home-manager.

```bash
sudo nixos-rebuild switch --flake ~/dev/dotfiles#nixos
ssh-add ~/.ssh/id_ed25519
```

After that `nh os switch` rebuilds from the repo, showing the build tree and a package diff between generations, and `nix flake update` followed by a switch is the whole update. Channels are disabled; `nixos-rebuild switch --rollback` or a git revert undoes a change. The store is garbage-collected weekly (`--delete-older-than 14d`) and optimised by systemd timers. `, <program>` runs anything from nixpkgs without installing it, with the prebuilt nix-index database also answering command-not-found; `nix-tree` and `nvd` show what takes up space and what changed between generations.

`nix fmt` formats the Nix files with nixfmt, and `nix develop` opens a shell with nixfmt, sops, age and nvd for working on the repo. `direnv` with `nix-direnv` is enabled in home-manager, so a project with its own `flake.nix` and an `.envrc` containing `use flake` gets its toolchain on `cd`. CI runs `nix flake check` on every push, and every Monday a workflow runs `nix flake update`, checks the result and opens a pull request with the new `flake.lock`; the repository has to allow GitHub Actions to create pull requests (Settings → Actions → General).

NixOS has no FHS `/usr/bin`, so an activation script compiles a wrapper for every system binary into `/usr/local/bin`, plus `/bin/bash`. `#!/usr/bin/env` scripts and `wsl.exe -e <cmd>` from Windows find their tools that way. envfs solves the same problem lazily, but a lookup through it costs 0.3–1.3 s when called from `wsl.exe`.

Opening a text file from Explorer lands in Helix: `windows/terminal/install-helix-open.ps1` points the text extensions at `helix-open.vbs`, which focuses Optimum and runs `hx-open-tab` from `nixos/configuration.nix`. That script opens a herdr tab named after the file, rooted at its git repository, and starts `hx` there. The extension list comes from a scan of every drive and covers text, config and source formats, Steam's `.vdf`/`.acf` included, while scripts that run on double-click (`.bat`, `.cmd`, `.vbs`, `.ahk`, `.reg`) are left alone. The installer finds `optimum.exe` in Program Files or in the per-user install, passes its path to the launcher and uses it for the Open with icon, and drops the per-user choice Windows stores for each extension, so `Ctrl+,` in Optimum opens `config.toml` in Helix as well. Extensions it still cannot claim are listed at the end and have to be switched once through Open with → Always; `-Uninstall` reverts the rest.

home-manager owns `~/.zshrc`, `~/.zshenv`, `~/.config/git/config`, `~/.ssh/config`, neovim with `EDITOR`, fzf, zoxide and dircolors. Every managed file lands in `$HOME` as a real copy, not a symlink: `home/copy-files.nix` replaces the home-manager link step with a copy step, keeps the list of copied paths in `~/.local/state/home-manager/copied-files` and removes the ones a new generation drops. A file in the way that home-manager never wrote is moved aside as `<name>.hm-backup`. A repo edit, `windows/herdr/config.toml` and `herdr-nav` included, takes effect after the next switch; the flake sets `self.submodules`, so the `windows` submodule is part of the build. The same module runs on macOS. neovim keeps its own `~/.config/nvim` repo: `sideloadInitLua` passes the generated settings through the wrapper instead of writing `init.lua`.

Secrets go through [sops-nix](https://github.com/Mic92/sops-nix): `secrets/secrets.yaml` is encrypted to the age key in `~/.config/sops/age/keys.txt`, and the `sops-nix` user unit decrypts into `$XDG_RUNTIME_DIR/secrets`, then copies `~/.wakatime.cfg` and `~/.config/ngrok/ngrok.yml` into place with mode `600`; on macOS the launchd agent decrypts into the user temp dir and an activation step copies them once it is done. The key is not in git — keep a copy elsewhere, a new machine needs it to decrypt. `sops secrets/secrets.yaml` edits the file in place. The railway token stays in `~/.railway/config.json`, since `railway login` rewrites it.

Docker runs on the NixOS engine only, `lazydocker` is the dashboard.

`herdr-navd` runs `herdr-nav serve`, which listens on `127.0.0.1:47391`. AutoHotkey sends `tab next` and friends over WinSock, about 0.5 ms per keypress instead of ~120 ms for spawning `wsl.exe`, and falls back to `wsl.exe -e herdr-nav` when the socket is down.

## zsh

`home/zsh.nix` builds the shell on both systems, and the shell itself lives in `shared/zsh`: `env.zsh` sets the environment and PATH from `.zshenv`, `startup.zsh` runs early, `rc.zsh` holds the history, aliases, prompt, completion styles, highlight colours and widgets. home-manager only adds the plugins and syntax highlighting around them, and `mac/zsh/.zshrc` does the same with Homebrew on the Mac without Nix. git works the same way: `shared/git/config` holds the settings, `home/git.nix` includes it and adds the user. Git aliases come from the Oh My Zsh `git` plugin, vendored with its `lib/git.zsh` dependency and MIT licence under `shared/zsh/ohmyzsh/`, so no Oh My Zsh install is needed; it is sourced after `compinit` because it registers completions. Anything machine-specific goes into `~/.zshrc.local`, which is sourced early and never committed.

The command line uses Helix keybindings from [zsh-helix-mode](https://github.com/Multirious/zsh-helix-mode), vendored with its MIT licence under `shared/zsh/zsh-helix-mode/` at commit `e8d4940`. It replaces the vi keymap zsh would otherwise pick because `EDITOR=nvim`. It is sourced before syntax-highlighting, and `zhm-add-update-region-highlight-hook` runs after syntax-highlighting so the selection stays visible. To update, copy `LICENSE`, `zsh-helix-mode.zsh` and `zsh-helix-mode.plugin.zsh` from a newer commit and change the hash here.

The prompt is bash-style with a git branch via `vcs_info`. Accent colour `#FFBAF3` is shared with the syntax highlighting.

On NixOS `SSH_AUTH_SOCK` points at `$XDG_RUNTIME_DIR/ssh-agent.socket`, served by the `ssh-agent` user unit from the NixOS config, which is what stops git from asking for the key passphrase on every push. `~/.ssh/config` carries `AddKeysToAgent yes`, so the passphrase is asked once per WSL start and then never again, and linger keeps the agent alive after the last terminal closes.

## Helix

`shared/helix/` is copied as a whole to `~/.config/helix` by `home/helix.nix`, which also installs Helix with the language servers, the same on both systems. Helix picks the server for each language itself, and only the servers it picks are installed. `languages.toml` only adds what Helix has no default for: ESLint for JS/TS and Vue, and Prettier as the formatter for JS/TS, Vue and HTML/CSS/SCSS. Python, YAML, XML, Markdown, Twig and SQL have no server: tree-sitter highlighting is enough there.

| Language | Server | Nix package (`home/helix.nix`) |
|---|---|---|
| JS/TS | `typescript-language-server` | `typescript-language-server` |
| Vue | `vuels` | `vue-language-server` |
| HTML, CSS/SCSS, ESLint | `vscode-html-language-server`, `vscode-css-language-server`, `vscode-eslint-language-server` | `vscode-langservers-extracted` |
| Formatter for JS/TS, Vue, HTML/CSS/SCSS | `prettier` | `prettier` |
| Java | `jdtls` | `jdt-language-server` |
| Kotlin | `kotlin-language-server` | `kotlin-language-server` |
| Ruby | `ruby-lsp` | `ruby-lsp` |
| PHP | `intelephense` | `intelephense` |
| Rust | `rust-analyzer` | `rust-analyzer-unwrapped` |
| Lua | `lua-language-server` | `lua-language-server` |
| Clojure | `clojure-lsp` | `clojure-lsp` |
| Bash | `bash-language-server` | `bash-language-server` |
| Nix | `nil` | `nil` |
| TOML | `taplo` | `taplo` |
| Dockerfile | `docker-langserver` | `dockerfile-language-server` |
| Compose | `docker-compose-langserver` | `docker-compose-language-service` |

Language servers are editor tooling, so they come from Nix on both systems, `rust-analyzer` included. Runtimes and compilers belong to the code, so they come from version managers that read the project's own files: fnm with `.node-version`, rustup with `rust-toolchain.toml`, rbenv with `.ruby-version`; projects never depend on Nix. The servers still use the project's libraries and configs: `typescript` and `eslint` from `node_modules`, Prettier's config from the project, and `rust-src` and the proc-macro server from the active rustup toolchain, which is why the flake takes `rust-analyzer-unwrapped` without the Nix `RUST_SRC_PATH`. `home/helix.nix` wraps `hx` with the servers prepended to `PATH`, so a binary from `npm i -g` or a rustup proxy in `~/.cargo/bin` never shadows them; they stay invisible to the shell. Each built-in theme has a `_transparent` variant with the background removed from the editor and the statusline, so the terminal's background shows through.

## herdr

The same `hjkl` navigation on both systems — `h`/`l` switch tabs, `j`/`k` switch workspaces, adding `shift` switches agents with `j`/`k` and panes with `h`/`l` — but reached in two different ways, because only macOS can express it in herdr's own config.

macOS uses `alt`: Ghostty passes Option through as Alt, so herdr sees the combo itself. `home/herdr.nix` copies `mac/herdr/config.toml` there and `windows/herdr/config.toml` on NixOS.

The one third-party plugin is [reviewr](https://github.com/persiyanov/herdr-reviewr): it shows the agent's diff in a pane, lets you comment on lines and sends the comments back to the agent. `alt+shift+r` toggles it on macOS, `lwin+shift+r` on Windows. It opens in its own tab, set by `toggle_placement` in `shared/herdr/reviewr.toml`. reviewr always names that tab `reviewr`, so the toggle goes through a wrapper that waits for that tab, renames it to `Git Review` and focuses it: `shared/herdr/git-review.sh`, copied to `~/.local/bin/herdr-git-review`, on macOS and NixOS, and `herdr-nav reviewr` on Windows. On both systems `home/herdr.nix` builds the plugin root from the release binary and the manifest of a pinned tag, and a home-manager activation step runs `herdr plugin link` on that store path whenever it changes, so the version moves with the flake. The root is read-only, which reviewr is fine with: it only writes under `~/.local/state` and `~/.local/bin`.

The local plugin `shared/herdr/workspace-tabs` listens to `workspace.created` and turns every new workspace into five tabs in a fixed order — `Claude`, `Code`, `Terminal`, `Git`, `Daemon` — all rooted at the workspace directory, with focus back on `Claude`. The same script runs as the `kremeshnoi.workspace-tabs.bootstrap` action for a workspace that already exists and only adds the tabs it is missing. It is registered from its store copy by the same activation step, so an edit applies after the next switch.

Windows runs the same jumps on `lwin` without touching `[keys]` at all. Win combos never reach a TUI sitting behind the terminal, so AutoHotkey catches the key on the Windows side and hands it to `herdr-nav` running as `herdr-navd` inside NixOS, which drives herdr over its socket API. Those six entries are blanked out in the Windows copy of `config.toml` to keep a single path per action; `lwin+shift+h` / `lwin+shift+l` focus panes and `lwin+shift+r` toggles the reviewr pane the same way, and `prefix = "ctrl+z"` with the arrows stays for the up and down neighbours. Both files live in [win-ricing](https://github.com/kremeshnoi/win-ricing) under `herdr/`, together with the setup notes and the registry policy that frees `Win+L`.

## Claude Code

`shared/claude/skills/` holds the Claude Code skills shared between machines, currently `commit`. Only the skills are copied into `~/.claude/skills`, by `home/claude.nix`; `CLAUDE.md`, history, credentials, `settings.json`, commands, output styles and the `skills/synced` folder Claude manages itself stay local. Every folder under `shared/claude/skills/` becomes its own `~/.claude/skills/<name>` folder, so a new skill only needs a switch.
