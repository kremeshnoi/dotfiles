#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

detect_os() {
  if [[ "$OSTYPE" == darwin* ]]; then
    echo "macos"
  elif [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "${ID:-linux}"
  else
    echo "linux"
  fi
}

install_deps_macos() {
  if ! command -v brew >/dev/null; then
    echo "Homebrew not found. Install from https://brew.sh first." >&2
    exit 1
  fi
  brew install zsh zsh-autosuggestions zsh-syntax-highlighting fzf zoxide neovim
}

install_deps_ubuntu() {
  sudo apt update
  sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting fzf neovim
  if ! command -v zoxide >/dev/null; then
    if apt-cache show zoxide >/dev/null 2>&1; then
      sudo apt install -y zoxide
    else
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
  fi
}

link_zshrc() {
  local target="$HOME/.zshrc"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$target" "$backup"
    echo "Backed up existing .zshrc → $backup"
  fi
  ln -sf "$REPO_DIR/.zshrc" "$target"
  echo "Linked $REPO_DIR/.zshrc → $target"
}

OS="$(detect_os)"
echo "Detected OS: $OS"

case "$OS" in
  macos)
    install_deps_macos
    ;;
  ubuntu|debian)
    install_deps_ubuntu
    ;;
  nixos)
    echo "On NixOS — manage packages declaratively in your nix config."
    echo "Required: zsh, zsh-autosuggestions, zsh-syntax-highlighting, fzf, zoxide, neovim"
    ;;
  *)
    echo "Unknown OS '$OS' — install dependencies manually:"
    echo "  zsh, zsh-autosuggestions, zsh-syntax-highlighting, fzf, zoxide, neovim"
    ;;
esac

link_zshrc

echo
echo "Done. Restart your shell or run: exec zsh"
