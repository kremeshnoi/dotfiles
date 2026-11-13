# Rules

## Where a file goes

1. **Works on any OS** → `shared/`. If a file needs `if macOS` or a path that exists on one OS only, it does not belong there.
2. **Works on one OS, on every machine with that OS** → `mac/` or `windows/`.
3. **Packages, system options, services** → `nix/` for the machines with Nix, `mac/Brewfile` for the Mac without Nix.
4. **Only on one machine** → not in git: `~/.zshrc.local`, `~/.gitconfig` for the user and email, `~/.pg_service.conf`, `~/.ssh/config`.
5. The repo root holds only `nix/`, `shared/`, `mac/`, `windows/`, `docs/` and the files every repo has.

## Installers only place files

- `nix/home/*.nix` and `mac/install.sh` copy, link or generate files; they do not carry settings of their own. A setting written inline in Nix or in `install.sh` is a setting the other side does not get.
- When home-manager needs an option for something (`syntaxHighlighting.enable`, `programs.git.includes`), the values still come from `shared/`.

## Adding things

| To add | Do |
|---|---|
| a CLI tool | add it to `nix/darwin/configuration.nix` or `nix/home/default.nix` **and** to `mac/Brewfile`; the two lists are kept in sync by hand |
| a language server | `nix/home/helix.nix` **and** `mac/Brewfile`, plus `shared/helix/languages.toml` only if Helix has no default for it |
| a zsh alias, option or widget | `shared/zsh/rc.zsh` |
| an environment variable or a PATH entry | `shared/zsh/env.zsh`; macOS-only ones go to `mac/zsh/.zshrc`, Linux-only ones to `nix/home/default.nix` |
| a git setting | `shared/git/config` |
| a herdr setting | `mac/herdr/config.toml` and `windows/herdr/config.toml`; a herdr script or plugin goes to `shared/herdr/` |
| a herdr or reviewr upgrade | bump `shared/herdr/versions.toml` and the hashes in `nix/pkgs/herdr.nix` and `nix/home/herdr.nix` |
| a Claude skill | a folder under `shared/claude/skills/` |
| a secret | `sops shared/secrets/secrets.yaml`, then the target path in `nix/home/secrets.nix` and `mac/install.sh` |
| a decision that changes the layout | an ADR in `docs/adr/` |

## Never in git

- plain-text secrets, tokens, passwords; `.pg_service.conf` with a password belongs in `.gitignore` or in `~/.pgpass`;
- the age key `~/.config/sops/age/keys.txt`;
- anything a tool rewrites by itself (`~/.railway/config.json`, Claude history and credentials).

## Keybindings

The same action keeps the same letter on macOS and Windows wherever the platform allows it; see [keybindings.md](keybindings.md).

## Code and commits

- No comments in config files and scripts; names and structure carry the meaning.
- Conventional Commits; a breaking layout change carries `!` and a `BREAKING CHANGE:` footer saying what to do on a machine.
- A submodule change is committed and pushed in the submodule first, then bumped here.
- CI must stay green: `nix flake check ./nix` runs on every push.
