# Herdr Config

Config for [Herdr](https://herdr.dev) — a terminal workspace manager for AI coding agents.

## What's in it

- Gruvbox theme, sounds off, agent labels on pane borders
- Prefix-free `alt` navigation:
  - tabs — `alt+h` / `alt+l`
  - agents — `alt+k` / `alt+j`
  - workspaces (spaces) — `alt+shift+k` / `alt+shift+j`
- ASCII input source auto-switch in prefix mode (experimental)

Everything else stays on Herdr defaults, including the `ctrl+b` prefix.

## Install

```sh
./install.sh
```

The installer backs up any existing config, copies `config.toml` → `~/.config/herdr/config.toml` (a real file, not a symlink; re-run `./install.sh` after editing the repo to sync), and reloads the running server.

Herdr itself:

```sh
brew install herdr
```

## macOS note

The `alt` bindings need Option to be sent as Alt by the terminal. In Ghostty that is `macos-option-as-alt = true`, already set in [`../ghostty/config`](../ghostty/config).

## License

[Unlicense](../LICENSE) — public domain.
