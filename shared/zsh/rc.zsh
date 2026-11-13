zsh_shared="${${(%):-%x}:A:h}"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY
unsetopt BEEP LIST_BEEP HIST_BEEP

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias v='nvim'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='claude --dangerously-skip-permissions'

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 'ma=27;01'

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{#FFBAF3}${vcs_info_msg_0_}%f$ '

source "$zsh_shared/ohmyzsh/lib/git.zsh"
source "$zsh_shared/ohmyzsh/plugins/git/git.plugin.zsh"
source "$zsh_shared/fzf-git-branch.zsh"

typeset -U path PATH

unalias claude 2>/dev/null
function claude {
  command claude-trust "$PWD" 2>/dev/null
  command claude "$@"
}

typeset -gA ZSH_HIGHLIGHT_STYLES
for style in command builtin function alias suffix-alias global-alias hashed-command autodirectory reserved-word precommand; do
  ZSH_HIGHLIGHT_STYLES[$style]='fg=#FFBAF3'
done
for style in path path_pathseparator path_prefix path_prefix_pathseparator; do
  ZSH_HIGHLIGHT_STYLES[$style]='none'
done
unset style zsh_shared
