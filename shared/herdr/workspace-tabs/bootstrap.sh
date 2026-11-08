#!/usr/bin/env bash
set -euo pipefail

tabs=(Claude Code Terminal Git Daemon)
herdr="${HERDR_BIN_PATH:-herdr}"

workspace="${HERDR_WORKSPACE_ID:-}"
if [ -z "$workspace" ] && [ -n "${HERDR_PLUGIN_EVENT_JSON:-}" ]; then
  workspace="$(jq -r 'first(.. | objects | .workspace_id? // empty)' <<<"$HERDR_PLUGIN_EVENT_JSON")"
fi
[ -n "$workspace" ] || exit 0

existing="$("$herdr" tab list --workspace "$workspace" | jq -r '.result.tabs[].label')"
first="$("$herdr" tab list --workspace "$workspace" | jq -r '.result.tabs[0].tab_id')"
cwd="$("$herdr" pane list --workspace "$workspace" | jq -r --arg tab "$first" 'first(.result.panes[] | select(.tab_id == $tab) | .cwd) // empty')"

if [ "$(wc -l <<<"$existing")" -eq 1 ] && ! grep -qx "${tabs[0]}" <<<"$existing"; then
  "$herdr" tab rename "$first" "${tabs[0]}" >/dev/null
  existing="${tabs[0]}"
fi

for label in "${tabs[@]}"; do
  grep -qx "$label" <<<"$existing" && continue
  "$herdr" tab create --workspace "$workspace" --label "$label" ${cwd:+--cwd "$cwd"} >/dev/null
done

"$herdr" tab focus "$first" >/dev/null
