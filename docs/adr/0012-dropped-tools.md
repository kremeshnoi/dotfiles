# 0012. Dropped tools

- Status: accepted
- Date: 2026-11-13

## Context

Some tools were set up on every machine but no longer used. Each of them still cost a package on both sides, a config, and drift between the machines.

## Decision

These are removed from every machine and from the repo, and are not added back without the user asking:

| Tool | What went with it |
|---|---|
| neovim | `programs.neovim` with the Python and Ruby providers, `alias v`, the Homebrew formula, `tree-sitter` and `tree-sitter-cli`, `luarocks`, `~/.config/nvim`, the nvim data dirs and the local `nvim-config` checkout; the `kremeshnoi/nvim-config` repo stays on GitHub |
| wakatime | `wakatime-cli` in Nix and Homebrew, its secret, `~/.wakatime*` |
| ngrok | the package and cask, its secret, `~/.config/ngrok` |
| secrets | with wakatime and ngrok gone nothing was left to encrypt: `shared/secrets/`, `.sops.yaml`, sops-nix, `nix/home/secrets.nix`, the decrypt step in `install.sh`, `sops` and `age` ([0008](0008-secrets-with-sops-and-age.md) is superseded) |
| Ruby | `ruby-lsp` in Helix and on NixOS, rbenv with `RBENV_ROOT` and its PATH entry, `ruby-build`, Homebrew `ruby`, `~/.rbenv`, `~/.gem` |
| herdr goto | `shared/herdr/goto.sh`, `~/.local/bin/herdr-goto`, `alt+shift+f` in both herdr configs and `lwin+shift+f` in AutoHotkey |
| claude wrapper | the `claude` function in `rc.zsh`, which called a `claude-trust` that never existed |

Helix is the editor: `EDITOR`, `VISUAL` and git's `core.editor` are `hx`.

## Consequences

- [ADR 0007](0007-editor-tooling-vs-runtimes.md) still holds for Node and Rust; its rbenv line no longer applies.
- A tool that needs a credential again keeps it on the machine; bringing a secret store back needs a new ADR.
- macOS keeps its system Ruby in `/usr/bin`, which is not ours to remove.
- `.rb` stays in the list of extensions Windows opens in Helix: it only decides which editor opens a text file.
