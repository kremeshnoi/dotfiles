# Rules

## Where a file goes

1. **Works on any OS** → `shared/`. If a file needs `if macOS` or a path that exists on one OS only, it does not belong there.
2. **Works on one OS, on every machine with that OS** → `mac/` or `windows/`.
3. **Packages, system options, services** → `nix/` for the machines with Nix, `mac/Brewfile` for the Mac without Nix.
4. **Only on one machine** → not in git: `~/.zshrc.local`, `~/.gitconfig` for the user and email, `~/.pg_service.conf`, `~/.ssh/config`.
5. The repo root holds only `nix/`, `shared/`, `mac/`, `windows/`, `docs/`, the files every repo has and `.claude/CLAUDE.md`, the entry point for agents.

## What the dotfiles manage

The dotfiles manage what they declare, not everything on a machine. A machine may carry more: Homebrew formulae, npm globals, apps installed for one job or one employer. That is fine and stays out of the repo. Two things are not fine:

1. **A gap in the managed set.** Everything the repo declares for the Macs is declared for both of them, and everything shared with NixOS is declared there too. The exceptions are explicit lists in `.github/scripts/packages.py`: Nix tooling (`nh`, `nvd`, `nix-tree`, `nil`), the NixOS-only toolchain, and Mac apps. The script runs in CI and fails on any other difference; names that differ between Nix and Homebrew are mapped there.
2. **A conflict with the managed set.** An extra local package must not replace or shadow a managed one: the same tool from a second source (Homebrew and npm, Homebrew and a curl installer), a second copy earlier in `PATH`, or a local config file in a path the repo owns. When a managed tool needs to come from somewhere else on one machine, the repo says so (like `intelephense` from npm on the Mac without Nix).

Neither installer removes extras: `brew bundle` runs without cleanup and nix-darwin has `onActivation.cleanup = "none"`.

## Installers only place files

- `nix/home/*.nix` and `mac/install.sh` copy, link or generate files; they do not carry settings of their own. A setting written inline in Nix or in `install.sh` is a setting the other side does not get.
- When home-manager needs an option for something (`syntaxHighlighting.enable`, `programs.git.includes`), the values still come from `shared/`.

## Adding things

| To add | Do |
|---|---|
| a CLI tool | add it to `nix/home/default.nix` (every Nix machine) or `nix/darwin/configuration.nix` **and** to `mac/Brewfile`, then run `python3 .github/scripts/packages.py`; a different name on one side goes into its `brew_to_nix` map, a tool for one machine only into its exception lists |
| a language server | `nix/home/helix.nix` **and** `mac/Brewfile`, plus `shared/helix/languages.toml` only if Helix has no default for it |
| a zsh alias, option or widget | `shared/zsh/rc.zsh` |
| an environment variable or a PATH entry | `shared/zsh/env.zsh`; macOS-only ones go to `mac/zsh/.zshrc`, Linux-only ones to `nix/home/default.nix` |
| a git setting | `shared/git/config` |
| a herdr setting | `mac/herdr/config.toml` and `windows/herdr/config.toml`; a herdr script or plugin goes to `shared/herdr/` |
| a herdr or reviewr upgrade | bump `shared/herdr/versions.toml` and the hashes in `nix/pkgs/herdr.nix` and `nix/home/herdr.nix` |
| a Claude skill | a folder under `shared/claude/skills/` |
| a decision that changes the layout | an ADR in `docs/adr/` |

## Never in git

- secrets, tokens, passwords, plain or encrypted: the repo has no secret store; `.pg_service.conf` with a password belongs in `.gitignore` or in `~/.pgpass`;
- anything a tool rewrites by itself (`~/.railway/config.json`, Claude history and credentials).

## Keybindings

The same action keeps the same letter on macOS and Windows wherever the platform allows it; see [keybindings.md](keybindings.md).

## Code and commits

- No comments in config files and scripts; names and structure carry the meaning.
- Conventional Commits; a breaking layout change carries `!` and a `BREAKING CHANGE:` footer saying what to do on a machine.
- A submodule change is committed and pushed in the submodule first, then bumped here.
- CI must stay green: `nix flake check ./nix` runs on every push.
