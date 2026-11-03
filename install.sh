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

if [ ! -e /etc/NIXOS ]; then
  link shared/zsh/.zshrc "$HOME/.zshrc"
  link shared/shell/env.sh "$HOME/.config/shell/env.sh"
  link shared/zsh/ohmyzsh "$HOME/.config/zsh/ohmyzsh"
  link shared/helix "$HOME/.config/helix"
fi

herdr_plugins=(persiyanov/herdr-reviewr)

if [ "$(uname -s)" = Darwin ] && command -v herdr >/dev/null; then
  installed="$(herdr plugin list)"
  for plugin in "${herdr_plugins[@]}"; do
    if grep -q "github:$plugin@" <<<"$installed"; then
      echo "ok      herdr plugin $plugin"
    else
      herdr plugin install "$plugin" -y
    fi
  done
fi

if [ "$(uname -s)" = Darwin ]; then
  link mac/herdr/config.toml "$HOME/.config/herdr/config.toml"
  link shared/herdr/reviewr.toml "$HOME/.config/herdr/plugins/config/persiyanov.reviewr/config.toml"
  link shared/herdr/git-review.sh "$HOME/.local/bin/herdr-git-review"
  link mac/glazewm/config.yaml "$HOME/.glzr/glazewm/config.yaml"
  link mac/glazewm/kill-workspace.sh "$HOME/.glzr/glazewm/kill-workspace.sh"
  link mac/swiftbar/glazewm.sh "$HOME/.config/swiftbar/glazewm.sh"
  defaults write com.ameba.SwiftBar PluginDirectory "$HOME/.config/swiftbar"
fi
