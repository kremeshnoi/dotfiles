#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

install_keybindings() {
  local dir target
  dir="$(warp_config_dir)"
  target="$dir/keybindings.yaml"
  mkdir -p "$dir"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$target" "$backup"
    echo "Backed up existing keybindings.yaml -> $backup"
  fi
  cp "$REPO_DIR/keybindings.yaml" "$target"
  echo "Copied $REPO_DIR/keybindings.yaml -> $target"
}

install_keybindings

echo
echo "Done. Restart Warp to apply."
