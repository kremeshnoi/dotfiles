# Helix

`shared/helix/` is the whole Helix config. Nix copies it to `~/.config/helix` and installs Helix with the language servers in `nix/home/helix.nix`; the Mac without Nix links it and installs the same servers from `mac/Brewfile`.

Helix picks the server for each language itself, and only the servers it picks are installed. `languages.toml` adds only what Helix has no default for: ESLint for JS/TS and Vue, and Prettier as the formatter for JS/TS, Vue and HTML/CSS/SCSS. Python, YAML, XML, Markdown, Twig and SQL have no server: tree-sitter highlighting is enough there.

| Language | Server | Nix package | Homebrew |
|---|---|---|---|
| JS/TS | `typescript-language-server` | `typescript-language-server` | `typescript-language-server` |
| Vue | `vuels` | `vue-language-server` | `vue-language-server` |
| HTML, CSS/SCSS, ESLint | `vscode-html-language-server`, `vscode-css-language-server`, `vscode-eslint-language-server` | `vscode-langservers-extracted` | `vscode-langservers-extracted` |
| Formatter for JS/TS, Vue, HTML/CSS/SCSS | `prettier` | `prettier` | `prettier` |
| Java | `jdtls` | `jdt-language-server` | `jdtls` |
| Kotlin | `kotlin-language-server` | `kotlin-language-server` | `kotlin-language-server` |
| PHP | `intelephense` | `intelephense` | npm, see below |
| Rust | `rust-analyzer` | `rust-analyzer-unwrapped` | `rust-analyzer` |
| Lua | `lua-language-server` | `lua-language-server` | `lua-language-server` |
| Clojure | `clojure-lsp` | `clojure-lsp` | `clojure-lsp` |
| Bash | `bash-language-server` | `bash-language-server` | `bash-language-server` |
| Nix | `nil` | `nil` | — |
| TOML | `taplo` | `taplo` | `taplo` |
| Dockerfile | `docker-langserver` | `dockerfile-language-server` | `dockerfile-language-server` |
| Compose | `docker-compose-langserver` | `docker-compose-language-service` | `docker-compose-langserver` |

`hx` is wrapped on every machine so the managed servers come first in its `PATH`, and a binary from `npm i -g` or a rustup proxy in `~/.cargo/bin` never shadows them. With Nix the wrapper is built in `nix/home/helix.nix` and the servers stay invisible to the shell. Without Nix it is `mac/helix/hx`, linked to `~/.local/bin/hx` ahead of Homebrew's `hx`: it puts `intelephense` and `/opt/homebrew/bin` first and runs `/opt/homebrew/bin/hx`; the servers stay on the shell's `PATH` there. The flake takes `rust-analyzer-unwrapped` without the Nix `RUST_SRC_PATH`, so `rust-src` and the proc-macro server come from the active rustup toolchain. Why the servers come from the system while runtimes do not is in [ADR 0007](adr/0007-editor-tooling-vs-runtimes.md).

Homebrew has no `intelephense`, so `mac/install.sh` installs it with `npm install --prefix ~/.local/share/intelephense` at the version nixpkgs carries (`intelephense_version` in `install.sh`, now 1.18.2) and links it into `~/.local/bin`. A separate prefix keeps it independent of the Node version fnm has active; Node itself comes from fnm at run time. After a flake update, bump `intelephense_version` to the new nixpkgs version. Some features need a paid licence; the free part covers completion, navigation and diagnostics.

Each built-in theme has a `_transparent` variant with the background removed from the editor and the statusline, so the terminal's background shows through.
