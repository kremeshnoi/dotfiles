# ---- Helpers ----
_try_source() {
  for f in "$@"; do
    if [ -r "$f" ]; then source "$f"; return 0; fi
  done
  return 1
}

# ---- Shared env (PATH, aliases, fzf, SSH_AUTH_SOCK) ----
[ -r "$HOME/.config/shell/env.sh" ] && source "$HOME/.config/shell/env.sh"

# ---- Local overrides (per-machine, not committed) ----
[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

if [[ -o interactive && -z "$HERDR_ENV" && -z "$NO_HERDR" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" ]] && command -v herdr >/dev/null; then
  herdr && exit
fi

# ---- History ----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# ---- Completion ----
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Selected-entry in menu select: bold + explicitly no reverse-video (27) → no background
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 'ma=27;01'

# ---- Disable terminal bell (Tab completion / errors) ----
unsetopt BEEP LIST_BEEP HIST_BEEP

# ---- Bash-style prompt with git branch ----
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{#FFBAF3}${vcs_info_msg_0_}%f$ '

# ---- Plugins ----
_try_source \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fzf keybindings (Ctrl+R history, Ctrl+T files, Alt+C cd) and completion
_try_source \
  /usr/share/doc/fzf/examples/key-bindings.zsh \
  /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
  /home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh \
  /usr/local/opt/fzf/shell/key-bindings.zsh \
  "$HOME/.nix-profile/share/fzf/key-bindings.zsh"
_try_source \
  /usr/share/doc/fzf/examples/completion.zsh \
  /opt/homebrew/opt/fzf/shell/completion.zsh \
  /home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh \
  /usr/local/opt/fzf/shell/completion.zsh \
  "$HOME/.nix-profile/share/fzf/completion.zsh"

# zoxide: smart cd — use `z foo` to jump to frequent dirs
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
  /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ---- Claude Code: auto-trust the working directory ----
claude() {
  command claude-trust "$PWD" 2>/dev/null
  command claude "$@"
}
