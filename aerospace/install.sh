#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" != darwin* ]]; then
  echo "AeroSpace is macOS-only. Nothing to do on this OS." >&2
  exit 0
fi

if ! command -v aerospace >/dev/null && [ ! -d "/Applications/AeroSpace.app" ]; then
  echo "AeroSpace not found. Install it: brew install --cask nikitabobko/tap/aerospace"
fi

target="${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml"
mkdir -p "$(dirname "$target")"

if [ -e "$target" ] && [ ! -L "$target" ]; then
  backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
  cp "$target" "$backup"
  echo "Backed up existing config → $backup"
fi

ln -sf "$REPO_DIR/aerospace.toml" "$target"
echo "Linked $REPO_DIR/aerospace.toml → $target"
