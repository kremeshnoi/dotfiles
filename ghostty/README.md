# Ghostty Config

Config for the [Ghostty](https://ghostty.org) terminal.

## What's in it

- Black background at 80% opacity with 16px blur
- 16px font, thickened glyphs, extra cell height, balanced 20px window padding
- Hidden macOS titlebar
- Option sent as Alt, so TUIs like [herdr](../herdr) can bind `alt+…`
- Vim-style split navigation — `super+ctrl+hjkl` to focus, `super+ctrl+shift+hjkl` to create
- `super+n` unbound

## Install

```sh
./install.sh
```

The installer backs up any existing config and copies this repo's `config` (a real file, not a symlink; re-run `./install.sh` after editing the repo to sync):

- **macOS** → `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
- **Linux** → `~/.config/ghostty/config`

## License

[Unlicense](../LICENSE) — public domain.
