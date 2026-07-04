# ---- Helpers ----
_try_source() {
  for f in "$@"; do
    if [ -r "$f" ]; then source "$f"; return 0; fi
  done
  return 1
}

# ---- History ----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# ---- Completion ----
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 'ma=27;01'

# ---- Disable terminal bell ----
unsetopt BEEP LIST_BEEP HIST_BEEP

# ---- Bash-style prompt with git branch ----
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{#FFBAF3}${vcs_info_msg_0_}%f$ '

# ---- Plugins ----
# zsh-autosuggestions
_try_source \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fzf keybindings (Ctrl+R / Ctrl+T / Alt+C) and completion
_try_source \
  /usr/share/doc/fzf/examples/key-bindings.zsh \
  /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
  /usr/local/opt/fzf/shell/key-bindings.zsh \
  /run/current-system/sw/share/fzf/key-bindings.zsh \
  "$HOME/.nix-profile/share/fzf/key-bindings.zsh"
_try_source \
  /usr/share/doc/fzf/examples/completion.zsh \
  /opt/homebrew/opt/fzf/shell/completion.zsh \
  /usr/local/opt/fzf/shell/completion.zsh \
  /run/current-system/sw/share/fzf/completion.zsh \
  "$HOME/.nix-profile/share/fzf/completion.zsh"

# zoxide: smart cd
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# syntax-highlighting MUST be the last sourced plugin
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[function]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#FFBAF3'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='none'
_try_source \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ---- lesspipe (friendlier `less` on non-text files) ----
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ---- ls / grep colors ----
if command -v dircolors >/dev/null; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
elif [[ "$OSTYPE" == darwin* ]]; then
    # BSD ls on macOS
    export CLICOLOR=1
    alias grep='grep --color=auto'
fi

# ---- Aliases ----
command -v nvim >/dev/null && alias vi='nvim'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
command -v claude >/dev/null && alias claude='claude --dangerously-skip-permissions'

# ---- PATH / env ----
export FLYCTL_INSTALL="$HOME/.fly"
export RBENV_ROOT="$HOME/.rbenv"
export DENO_INSTALL="$HOME/.deno"
export FNM_PATH="$HOME/.local/share/fnm"
export PATH="$FLYCTL_INSTALL/bin:$HOME/.cargo/bin:$RBENV_ROOT/bin:$RBENV_ROOT/shims:$DENO_INSTALL/bin:$FNM_PATH:/opt/nvim:/usr/local/go/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ---- rbenv ----
command -v rbenv >/dev/null && eval "$(rbenv init - zsh)"

# ---- User tools ----
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# ---- Local overrides (per-machine, not committed) ----
[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
