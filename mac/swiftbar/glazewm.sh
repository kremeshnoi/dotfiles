#!/bin/bash
# <swiftbar.type>streamable</swiftbar.type>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

glazewm=/opt/homebrew/bin/glazewm
jq=/usr/bin/jq

render() {
  local workspaces
  workspaces=$("$glazewm" query workspaces 2>/dev/null) || return
  echo "~~~"
  echo "$workspaces" | "$jq" -r --arg glazewm "$glazewm" '
    .data.workspaces as $all
    | ([$all[] | select(.hasFocus)][0].displayName // "—"),
      "---",
      ($all[] | "\(if .hasFocus then "✓ " else "    " end)\(.displayName) | bash=\($glazewm) param1=command param2=focus param3=--workspace param4=\(.name) terminal=false")
  '
}

while true; do
  render
  "$glazewm" sub -e workspace_activated focus_changed workspace_updated 2>/dev/null | while read -r _; do
    render
  done
  sleep 2
done
