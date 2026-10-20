#!/bin/bash

glazewm=/opt/homebrew/bin/glazewm
protected='^(Finder|GlazeWM|zebar)$'

workspace=$("$glazewm" query workspaces | /usr/bin/jq -c '[.data.workspaces[] | select(.hasFocus)][0] // empty')
[ -z "$workspace" ] && exit 0

windows=$(echo "$workspace" | /usr/bin/jq -r '.. | objects | select(.type == "window") | [.id, .processName] | @tsv')
[ -z "$windows" ] && exit 0

"$glazewm" command focus --recent-workspace >/dev/null

echo "$windows" | while IFS=$'\t' read -r id app; do
  if [[ "$app" =~ $protected ]]; then
    "$glazewm" command --id "$id" close >/dev/null
  fi
done

echo "$windows" | cut -f2 | sort -u | grep -Ev "$protected" | while read -r app; do
  /usr/bin/osascript -e "quit app \"$app\"" >/dev/null 2>&1
done
