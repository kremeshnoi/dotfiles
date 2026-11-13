# 0005. A Mac without Nix is set up by Homebrew and symlinks

- Status: accepted
- Date: 2026-11-13

## Context

The work Mac may not run Nix or nix-darwin. It still needs the same shell, editor, window manager and herdr setup as the Mac at home.

## Decision

- `mac/install.sh` sets it up: `brew bundle` on `mac/Brewfile`, symlinks from `$HOME` into the checkout for `shared/` and `mac/`, herdr plugins at the pinned versions, pgf, and the secrets when an age key is present.
- Links, not copies: an edit in the checkout applies at once.
- A file in the way is moved to `<name>.backup-<timestamp>`; running the script again is safe.
- Machine-specific settings stay out of git: `~/.zshrc.local`, `~/.gitconfig`, `~/.ssh/config`, `~/.pg_service.conf`.

## Consequences

- The checkout must stay at `~/dev/dotfiles` with its submodules; moving it breaks the links.
- Two files cannot be links: the generated herdr config ([0010](0010-work-only-herdr-sidebar.md)) and the decrypted secrets. They need `install.sh` again after a change.
- `mac/Brewfile` has to follow the Nix package lists by hand ([0004](0004-shared-holds-os-independent-configs.md)).
