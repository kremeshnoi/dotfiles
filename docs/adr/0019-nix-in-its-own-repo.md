# 0019. `nix/` is its own repo

- Status: accepted
- Date: 2026-11-19

## Context

`mac/` and `windows/` were separate repos, `nix/` was a plain directory. Its modules reached `shared/` through `../../shared`, which works only while the flake sits inside the dotfiles checkout: Nix copies the whole git repo of a flake in a subdirectory. A flake in its own repo sees only that repo.

## Decision

- `nix/` is the submodule `nix-config` (`git@github.com:kremeshnoi/nix-config.git`), with the history it had under `nix/`.
- The flake takes `shared/` from the input `dotfiles = { url = "github:kremeshnoi/dotfiles"; flake = false; }` and hands `shared = "${dotfiles}/shared"` to every module through `specialArgs` and `extraSpecialArgs`. No module uses `../../`.
- `self.submodules` is gone: no Nix module reads `mac/` or `windows/`.
- `nix-config` runs its own `nix flake check` and the weekly `flake.lock` update. Dotfiles CI checks the flake against its own `shared/` with `--override-input dotfiles`.

## Consequences

- A switch reads the `shared/` pinned in `nix/flake.lock`, not the checkout. A change to `shared/` reaches a Nix machine after a push and `nix flake update dotfiles` in `nix/`.
- To try a local change first: `nh os switch -- --override-input dotfiles git+file:$HOME/dev/dotfiles`, or `nh darwin switch -- …` on the Mac.
- A change in `nix/` is two commits, like `mac/` and `windows/`: one in `nix-config`, one bumping it here.
- `nix-config` has to be public, so the submodule clones without credentials and CI can fetch it.
- Amends [0009](0009-everything-nix-under-nix.md): the modules no longer reach the rest of the repo through `../../`.
