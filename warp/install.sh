#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_FILES=(keybindings.yaml settings.toml)

warp_config_dir() {
  if [[ "$OSTYPE" == darwin* ]]; then
    echo "$HOME/.warp"
  elif grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
    local win_user
    win_user="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')"
    echo "/mnt/c/Users/$win_user/AppData/Local/warp/Warp/config"
  elif [ -d "$HOME/.local/state/warp-terminal" ]; then
    echo "$HOME/.local/state/warp-terminal"
  else
    echo "$HOME/.warp"
  fi
}

install_config() {
  local dir file target backup
  dir="$(warp_config_dir)"
  mkdir -p "$dir"
  for file in "${CONFIG_FILES[@]}"; do
    target="$dir/$file"
    if [ -e "$target" ] && [ ! -L "$target" ] && ! cmp -s "$REPO_DIR/$file" "$target"; then
      backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
      cp "$target" "$backup"
      echo "Backed up existing $file -> $backup"
    fi
    cp "$REPO_DIR/$file" "$target"
    echo "Copied $REPO_DIR/$file -> $target"
  done
}

install_config

echo
echo "Done. Restart Warp to apply."
