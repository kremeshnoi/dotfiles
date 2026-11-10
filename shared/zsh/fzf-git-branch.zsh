_fzf_git_branch_insert() {
  git rev-parse --git-dir >/dev/null 2>&1 || return 0
  local refs=$1
  local -a words=(${(z)LBUFFER})
  local last="${LBUFFER##* }"
  local query=""
  if [[ -n "$last" ]]; then
    if (( ${#words} == 1 )) || [[ "$last" == -* ]] || [[ "${words[1]}" == git && ${#words} == 2 ]]; then
      LBUFFER+=' '
    else
      query="$last"
    fi
  fi
  local selected
  selected=$(
    git for-each-ref --sort=-committerdate --format='%(refname:lstrip=2)' "$refs" |
      grep -v '/HEAD$' |
      fzf --prompt='branch> ' --query="$query" \
        --preview 'git log --oneline --graph --color=always -20 {}' \
        --preview-window=right,60% \
        --bind 'tab:down,shift-tab:up' \
        --bind 'start:unbind(j,k,i,/,q)' \
        --bind 'esc:transform:[[ $FZF_PROMPT == "branch> " ]] && echo "change-prompt(branch [nav]> )+rebind(j,k,i,/,q)" || echo abort' \
        --bind 'j:down,k:up,q:abort' \
        --bind 'i:change-prompt(branch> )+unbind(j,k,i,/,q)' \
        --bind '/:change-prompt(branch> )+unbind(j,k,i,/,q)'
  )
  if [[ -n "$selected" ]]; then
    LBUFFER="${LBUFFER%$query}"
    [[ -n "$LBUFFER" && "$LBUFFER" != *' ' ]] && LBUFFER+=' '
    LBUFFER+="$selected"
  fi
  zle reset-prompt
}
fzf-git-local-branch-widget() { _fzf_git_branch_insert refs/heads }
fzf-git-remote-branch-widget() { _fzf_git_branch_insert refs/remotes }
zle -N fzf-git-local-branch-widget
zle -N fzf-git-remote-branch-widget
for __keymap in main emacs viins hxins hxnor; do
  bindkey -l | grep -qx "$__keymap" || continue
  bindkey -M "$__keymap" '^G' fzf-git-local-branch-widget
  bindkey -M "$__keymap" '^[[103;6u' fzf-git-remote-branch-widget
  bindkey -M "$__keymap" '^[[71;6u' fzf-git-remote-branch-widget
done
unset __keymap
