# Roadmap

Things not done yet. Each item says what is left and how to finish it.

## 1. First switch on the Mac at home

`darwinConfigurations.mac` evaluates in CI but has never been applied.

- Move the checkout: `~/dev/dotfiles/dotfiles` → `~/dev/dotfiles`, then `git submodule update --init`.
- Run the first switch from [machines.md § Mac with Nix](machines.md#mac-with-nix) and fix what breaks.
- Check with [verification.md](verification.md): shell, GNU `ls` colours, Ghostty font and palette, herdr config, `pgf`.

## 2. Switch NixOS

NixOS still runs the generation from before these changes: neovim, wakatime, ngrok, Ruby and sops are still there, `fnm`, `bat`, `psql` and `pspg` are not, and `ls`, the herdr config and the zsh files are old.

- `git pull && git submodule update --init`, then `nh os switch`.
- Run [verification.md § Shell](verification.md#shell) and `herdr config check`.
- Remove what home-manager no longer manages and nothing else uses: `~/.config/nvim`, `~/.local/share/nvim`, `~/.wakatime*`, `~/.config/ngrok`, `~/.rbenv`, `~/.gem`, `~/.config/sops`.

## 3. Docker Desktop on Windows

The NixOS engine is the only one in use: uninstall Docker Desktop and remove the `7-docker` GlazeWM workspace from `win-ricing`.

## 4. Version drift between Homebrew and Nix

Homebrew on the Mac without Nix is newer than the pinned nixpkgs (helix, fzf, git, ripgrep, fd and others). Only herdr is pinned on both sides. Decide per tool:

- accept the drift for tools whose config does not depend on the version;
- pin with `brew pin` and record the version next to the Nix one, as herdr does, for tools whose config does.

Record the decision as an ADR.

## 5. Fira Code Nerd Font on the work Mac

`font-fira-code-nerd-font` is installed but no managed config uses it; Ghostty uses JetBrainsMono Nerd Font. Check whether another app needs it, then uninstall it with `brew uninstall --cask font-fira-code-nerd-font` or leave it as a local extra.

## 6. Live links on the Nix machines

The Nix machines copy every file into `$HOME` ([ADR 0002](adr/0002-copy-home-files-instead-of-symlinking.md)), so an edit applies only after a switch; the Mac without Nix links them. Candidates for links into `~/dev/dotfiles`: `shared/helix`, the Claude skills, `shared/zsh`, and on the Mac GlazeWM, SwiftBar, Ghostty and herdr.

- Use `config.lib.file.mkOutOfStoreSymlink` for them.
- Teach `nix/home/copy-files.nix` to keep out-of-store links instead of copying through them (`cp -RL`).
- Keep generated files (`.zshrc`, `.zshenv`, git and ssh configs) as copies.
- Write an ADR that supersedes 0002, and update [links.md](links.md).
