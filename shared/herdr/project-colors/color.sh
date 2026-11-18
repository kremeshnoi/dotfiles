#!/usr/bin/env bash
set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
colors=(blue purple green yellow teal orange lime rust fernbloom white)

color_for() {
  case "$1" in
    "$HOME"/dev/otaku-library | "$HOME"/dev/otaku-library/*) echo blue ;;
    "$HOME"/dev/optimum | "$HOME"/dev/optimum/*) echo purple ;;
    "$HOME"/dev/turtle-van | "$HOME"/dev/turtle-van/*) echo green ;;
    "$HOME"/dev/edu/clojure-koans | "$HOME"/dev/edu/clojure-koans/*) echo lime ;;
    "$HOME"/dev/edu/rustlings | "$HOME"/dev/edu/rustlings/*) echo rust ;;
    "$HOME"/dev/edu | "$HOME"/dev/edu/*) echo yellow ;;
    "$HOME"/dev/nvim | "$HOME"/dev/nvim/*) echo teal ;;
    "$HOME"/dev/kremeshnoi | "$HOME"/dev/kremeshnoi/*) echo orange ;;
    "$HOME"/dev/fernbloom | "$HOME"/dev/fernbloom/*) echo fernbloom ;;
    *) echo white ;;
  esac
}

"$herdr" workspace list | jq -r '.result.workspaces[] | [.workspace_id, .label, ([(.tokens // {}) | keys[] | select(startswith("project_"))] | join(" "))] | @tsv' |
  while IFS=$'\t' read -r workspace label stale; do
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
    for token in $stale; do
      case " ${colors[*]} " in
        *" ${token#project_} "*) ;;
        *) args+=(--clear-token "$token") ;;
      esac
    done
    "$herdr" workspace report-metadata "$workspace" --source kremeshnoi.project-colors "${args[@]}" >/dev/null
  done
