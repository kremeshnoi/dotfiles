export EDITOR=hx
export VISUAL=hx
export LESS='-R -F -X -i'
export DENO_INSTALL="$HOME/.deno"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$DENO_INSTALL/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  $path
)
typeset -U path PATH
