export EDITOR=nvim
export VISUAL=nvim
export LESS='-R -F -X -i'
export RBENV_ROOT="$HOME/.rbenv"
export DENO_INSTALL="$HOME/.deno"
export FNM_PATH="$HOME/.local/share/fnm"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$RBENV_ROOT/bin"
  "$DENO_INSTALL/bin"
  "$FNM_PATH"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  $path
)
typeset -U path PATH
