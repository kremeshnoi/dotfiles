# ZSH Config

Portable zsh configuration with a cross-OS installer. One `.zshrc` that works on macOS, Ubuntu/Debian, NixOS, and WSL — silently skipping plugins that aren't installed on the current machine.

## What's in it

- **Bash-style prompt** with git branch via `vcs_info` (`user@host:path (branch)$`)
- **History** tuned for shared, dedup'd, incrementally-appended entries (10k lines)
- **Completion** with menu select, case-insensitive matching, and `LS_COLORS`
- **Plugins** (loaded only if present): `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf` keybindings + completion, `zoxide`
- **Custom syntax highlighting** — pink (`#FFBAF3`) for commands/builtins/functions, no path coloring
- **Silenced bell** (`BEEP`, `LIST_BEEP`, `HIST_BEEP` off)
- **Cross-platform `ls`/`grep` colors** — GNU `dircolors` on Linux, `CLICOLOR` on macOS
- **Tool env** preconfigured: `flyctl`, `rbenv`, `deno`, `fnm`, `cargo`, `nvim`, Go
- **Local override** — `~/.zshrc.local` is sourced last (gitignored) for per-machine secrets/tweaks

## Install

```sh
git clone https://github.com/kremeshnoi/zsh-config.git ~/.config/zsh-config
cd ~/.config/zsh-config
./install.sh
exec zsh
```

The installer:
1. Detects the OS (macOS / Ubuntu / Debian / NixOS / other)
2. Installs dependencies via `brew` or `apt` (NixOS users manage packages declaratively)
3. Backs up any existing `~/.zshrc` to `~/.zshrc.backup-YYYYMMDD-HHMMSS`
4. Symlinks `~/.zshrc` → this repo's `.zshrc`

## Per-machine overrides

Put anything machine-specific (work secrets, host-only aliases) in `~/.zshrc.local` — it's sourced at the end of `.zshrc` and ignored by git.

## License

[Unlicense](LICENSE) — public domain.
