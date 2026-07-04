# Ghostty Config

Config for the [Ghostty](https://ghostty.org) terminal.

## What's in it

- Black background at 80% opacity with 16px blur
- 16px font, thickened glyphs, extra cell height, balanced 20px window padding
- Hidden macOS titlebar
- Vim-style split navigation — `super+ctrl+hjkl` to focus, `super+ctrl+shift+hjkl` to create
- `super+n` unbound

## Install

```sh
./install.sh
```

The installer backs up any existing config and symlinks this repo's `config`:

- **macOS** → `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
- **Linux** → `~/.config/ghostty/config`

## License

[Unlicense](../LICENSE) — public domain.
