#!/usr/bin/env bash
set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
colors=(blue purple green red yellow teal orange white)

color_for() {
  case "$1" in
    "$HOME"/dev/otaku-library | "$HOME"/dev/otaku-library/*) echo blue ;;
    "$HOME"/dev/optimum | "$HOME"/dev/optimum/*) echo purple ;;
    "$HOME"/dev/turtle-van | "$HOME"/dev/turtle-van/*) echo green ;;
    "$HOME"/dev/dotfiles | "$HOME"/dev/dotfiles/*) echo red ;;
    "$HOME"/dev/edu | "$HOME"/dev/edu/*) echo yellow ;;
    "$HOME"/dev/nvim | "$HOME"/dev/nvim/*) echo teal ;;
    "$HOME"/dev/kremeshnoi | "$HOME"/dev/kremeshnoi/*) echo orange ;;
    *) echo white ;;
  esac
}

"$herdr" workspace list | jq -r '.result.workspaces[] | [.workspace_id, .label] | @tsv' |
  while IFS=$'\t' read -r workspace label; do
    first="$("$herdr" tab list --workspace "$workspace" | jq -r '.result.tabs[0].tab_id // empty')"
    [ -n "$first" ] || continue
    cwd="$("$herdr" pane list --workspace "$workspace" | jq -r --arg tab "$first" 'first(.result.panes[] | select(.tab_id == $tab) | .cwd) // empty')"
    color="$(color_for "$cwd")"
    args=()
    for name in "${colors[@]}"; do
      if [ "$name" = "$color" ]; then
        args+=(--token "project_$name=$label")
      else
        args+=(--clear-token "project_$name")
      fi
    done
    "$herdr" workspace report-metadata "$workspace" --source kremeshnoi.project-colors "${args[@]}" >/dev/null
  done
