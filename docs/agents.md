# For agents

Start here when asked to set up a machine, update it, or change the dotfiles. Everything below is meant to be followed literally.

## 1. Find out where you are

```bash
uname -s
command -v nix darwin-rebuild nixos-rebuild brew
whoami
git -C ~/dev/dotfiles rev-parse --show-toplevel 2>/dev/null
test -e /etc/NIXOS && echo nixos
```

| Result | Machine | Builder | Runbook |
|---|---|---|---|
| Linux, `/etc/NIXOS`, user `kremeshnoi` | NixOS under WSL | `nix/flake.nix#nixos` | [runbooks.md § NixOS](runbooks.md#set-up-nixos-under-wsl) |
| Darwin, `nix` present, user `kremeshnoi` | Mac with Nix | `nix/flake.nix#mac` | [runbooks.md § Mac with Nix](runbooks.md#set-up-a-mac-with-nix) |
| Darwin, no `nix`, any user | Mac without Nix | `mac/install.sh` | [runbooks.md § Mac without Nix](runbooks.md#set-up-a-mac-without-nix) |
| Windows | Windows host | by hand | [win-ricing README](https://github.com/kremeshnoi/win-ricing) |

The Nix configs hardcode the user `kremeshnoi`; a Mac with another user and no permission to change that goes the no-Nix way. See [runbooks.md § another user](runbooks.md#another-user-name).

Never install Nix on a machine without asking: on the work Mac it is not allowed.

## 2. Know the invariants

- The checkout is `~/dev/dotfiles`, cloned with `--recurse-submodules`.
- `shared/` works on any OS; `mac/` and `windows/` hold OS-only files; `nix/` and `mac/install.sh` only place files ([rules.md](rules.md)).
- A setting goes into exactly one file. If you are about to write the same value in a Nix file and in `mac/`, it belongs in `shared/`.
- `mac/` and `windows/` are separate repos. Commit and push inside them first, then commit the bumped submodule here.
- No comments in configs and scripts.
- The repo holds no secrets, encrypted or not; credentials stay on the machine.
- Anything a single machine needs goes to `~/.zshrc.local`, `~/.gitconfig` or another untracked file.
- Commit and push only when the user asks for it.
- Do not bring back a tool listed in [ADR 0012](adr/0012-dropped-tools.md) unless the user asks.

## 3. Find the file

[inventory.md](inventory.md) lists every tracked file, what it is for and who reads it. Look there before creating a new file.

[links.md](links.md) says which paths in `$HOME` are symlinks (only on the Mac without Nix), which are copies, and where each one points.

## 4. Change it

[runbooks.md](runbooks.md) has a procedure with the exact snippet for each common change: a package, a language server, a config file, a herdr bump, a plugin, a skill, a keybinding.

## 5. Prove it works

[verification.md](verification.md) lists the checks for each kind of change, including how to evaluate the Nix configs on a machine without Nix. Do not report a change as done before running them.

## 6. When something breaks

[troubleshooting.md](troubleshooting.md) collects the failures already met and their fixes: `Killed: 9` on macOS, GlazeWM paths, herdr's single config file, CI and submodules, home-manager ordering.

## 7. Before you finish

- [ ] the change lives in one place, in the right part of the repo
- [ ] every consumer is wired: the Nix module **and** `mac/install.sh`, or the reason one side does not need it
- [ ] [links.md](links.md) lists the new path for every machine
- [ ] `python3 .github/scripts/packages.py` prints `package lists in sync`
- [ ] the checks from [verification.md](verification.md) pass
- [ ] [inventory.md](inventory.md) and the topic page in `docs/` describe the new state
- [ ] a decision that changes the layout has an ADR in [adr/](adr/README.md)
- [ ] submodules are committed and pushed before the bump here, if the user asked for commits
