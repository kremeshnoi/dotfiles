command -v rbenv >/dev/null && eval "$(rbenv init - zsh)"
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --log-level quiet --shell zsh)"

[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

if [[ -o interactive && -z "$HERDR_ENV" && -z "$NO_HERDR" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" ]] && command -v herdr >/dev/null; then
  herdr && exit
fi
