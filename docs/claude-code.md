# Claude Code

`shared/claude/skills/` holds the Claude Code skills shared between machines, currently `commit`. Every folder under it becomes its own `~/.claude/skills/<name>` folder: `nix/home/claude.nix` copies them, `mac/install.sh` links them. A new skill needs a switch on the Nix machines and nothing on the Mac without Nix.

Only the skills are shared. `CLAUDE.md`, history, credentials, `settings.json`, commands, output styles and the `skills/synced` folder Claude manages itself stay local.

`shared/zsh/rc.zsh` wraps `claude` so it runs `claude-trust "$PWD"` first, and `c` is an alias for `claude --dangerously-skip-permissions`.
