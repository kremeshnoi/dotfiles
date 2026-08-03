#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v herdr >/dev/null; then
  echo "herdr not found. Install it: brew install herdr"
fi

target="${XDG_CONFIG_HOME:-$HOME/.config}/herdr/config.toml"
mkdir -p "$(dirname "$target")"

if [ -L "$target" ]; then
  rm "$target"
elif [ -e "$target" ]; then
  backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
  cp "$target" "$backup"
  echo "Backed up existing config → $backup"
fi

cp "$REPO_DIR/config.toml" "$target"
echo "Copied $REPO_DIR/config.toml → $target"

if command -v herdr >/dev/null; then
  herdr server reload-config >/dev/null 2>&1 || true
fi
