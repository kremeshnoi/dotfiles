# Secrets

`shared/secrets/secrets.yaml` is encrypted with [sops](https://github.com/getsops/sops) to the age recipient in `.sops.yaml`. It holds the wakatime and ngrok configs.

| Secret | Lands in |
|---|---|
| `wakatime` | `~/.wakatime.cfg` |
| `ngrok` | `~/.config/ngrok/ngrok.yml` |

Every machine decrypts it with the age key in `~/.config/sops/age/keys.txt`. The key is not in git: keep a copy elsewhere, a new machine needs it to decrypt.

- **NixOS** — the `sops-nix` user unit decrypts into `$XDG_RUNTIME_DIR/secrets`, then copies the files into place with mode 600.
- **Mac with Nix** — the sops-nix launchd agent decrypts into the user temp dir, and an activation step copies the files once it is done.
- **Mac without Nix** — `install.sh` runs `sops -d --extract` for each secret and writes it with mode 600; without a key it skips them.

The secrets are copies, not links into the store or the temp dir, so tools that check file permissions accept them.

`sops shared/secrets/secrets.yaml` edits the file in place. A new secret also needs its target path in `nix/home/secrets.nix` and in `mac/install.sh`.

Some credentials stay out of the repo on purpose: the railway token in `~/.railway/config.json`, since `railway login` rewrites it, and database passwords, which belong in `~/.pgpass`.
