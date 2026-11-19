# dotfiles

Configs for NixOS under WSL, a Mac with nix-darwin, a Mac without Nix and the Windows host.

Before setting up a machine, updating it or changing anything here, read `docs/agents.md` and follow it. It routes to:

- `docs/inventory.md` — every file, its purpose and who reads it
- `docs/runbooks.md` — exact steps and snippets for each kind of change
- `docs/verification.md` — the checks to run before calling a change done
- `docs/troubleshooting.md` — failures already met and their fixes
- `docs/rules.md` and `docs/adr/` — where things go and why

The short version:

- `shared/` works on any OS; `nix/home/nixos` and `nix/home/darwin` are the two Nix machines; `nix/` (nix-config), `mac/` (the work Mac) and `windows/` (the Windows host) are submodules; `nix/` and `mac/install.sh` copy files, never link them.
- One setting lives in one file; wire it into both `nix/` and `mac/install.sh`.
- A tool for both Nix machines goes to `home.packages` in `nix/home/default.nix`; keep `mac/Brewfile` in sync with it.
- Never install Nix, or commit and push without the user asking.
