# 0008. Secrets are encrypted with sops and age

- Status: accepted
- Date: 2026-10-28

## Context

wakatime and ngrok need their configs with API keys on every machine, and the repo is public.

## Decision

- `shared/secrets/secrets.yaml` is encrypted with sops to the age recipient in `.sops.yaml`.
- Each machine decrypts with the age key in `~/.config/sops/age/keys.txt`, which never goes into git.
- sops-nix decrypts on the Nix machines; `mac/install.sh` runs `sops -d` on the Mac without Nix.
- The decrypted files are copied into place with mode 600 instead of being linked.

## Consequences

- Anyone can clone the repo; only a machine with the key gets the secrets.
- Losing the key means re-encrypting with a new recipient and rewriting every secret.
- A new secret needs its target path in two places: `nix/home/secrets.nix` and `mac/install.sh`.
- Credentials a tool rewrites by itself (railway) stay out of the repo.
