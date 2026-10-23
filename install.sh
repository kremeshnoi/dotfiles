#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"

link() {
  local source="$repo/$1" target="$2"
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "ok      $target"
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    mv "$target" "$target.backup-$stamp"
    echo "backup  $target.backup-$stamp"
  fi
  ln -s "$source" "$target"
  echo "link    $target -> $source"
}

link shared/zsh/.zshrc "$HOME/.zshrc"
link shared/shell/env.sh "$HOME/.config/shell/env.sh"
link shared/zsh/ohmyzsh "$HOME/.config/zsh/ohmyzsh"

if [ "$(uname -s)" = Darwin ]; then
  link mac/glazewm/config.yaml "$HOME/.glzr/glazewm/config.yaml"
  link mac/glazewm/kill-workspace.sh "$HOME/.glzr/glazewm/kill-workspace.sh"
  link mac/swiftbar/glazewm.sh "$HOME/.config/swiftbar/glazewm.sh"
  defaults write com.ameba.SwiftBar PluginDirectory "$HOME/.config/swiftbar"
fi
