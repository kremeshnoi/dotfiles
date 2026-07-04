#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" == darwin* ]]; then
  target="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
else
  target="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
fi

mkdir -p "$(dirname "$target")"

if [ -e "$target" ] && [ ! -L "$target" ]; then
  backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
  cp "$target" "$backup"
  echo "Backed up existing config → $backup"
fi

ln -sf "$REPO_DIR/config" "$target"
echo "Linked $REPO_DIR/config → $target"
