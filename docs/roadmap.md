# Roadmap

Things not done yet. Each item says what is left and how to finish it.

## 1. First switch on the Mac at home

`darwinConfigurations.mac` evaluates in CI but has never been applied.

- Move the checkout: `~/dev/dotfiles/dotfiles` → `~/dev/dotfiles`, then `git submodule update --init`.
- Run the first switch from [runbooks.md § Mac with Nix](runbooks.md#set-up-a-mac-with-nix) and fix what breaks.
- Check with [verification.md](verification.md): shell, GNU `ls` colours, Optimum, herdr config.

## 2. Docker Desktop on Windows

The NixOS engine is the only one in use: uninstall Docker Desktop and remove the `7-docker` GlazeWM workspace from `win-ricing`.

## 3. Version drift between Homebrew and Nix

Homebrew on the Mac without Nix is newer than the pinned nixpkgs (helix, fzf, git and others). Only herdr is pinned on both sides. Decide per tool:

- accept the drift for tools whose config does not depend on the version;
- pin with `brew pin` and record the version next to the Nix one, as herdr does, for tools whose config does.

Record the decision as an ADR.

## 4. Fira Code Nerd Font on the work Mac

`font-fira-code-nerd-font` is installed but no managed config uses it; Ghostty uses JetBrainsMono Nerd Font. Check whether another app needs it, then uninstall it with `brew uninstall --cask font-fira-code-nerd-font` or leave it as a local extra.
