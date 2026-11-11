#!/usr/bin/env bash
set -euo pipefail

config="${HERDR_CONFIG_PATH:-$HOME/.config/herdr/config.toml}"

token_colors=$(
  grep -oE 'token = "\$[A-Za-z0-9_]+", fg = "#[0-9A-Fa-f]{6}"' "$config" 2>/dev/null |
    sed -E 's/token = "\$([A-Za-z0-9_]+)", fg = "(#[0-9A-Fa-f]{6})"/\1 \2/' |
    jq -Rn '[inputs | split(" ") | {(.[0]): .[1]}] | add // {}'
)

rows=$(jq -rn \
  --argjson ws "$(herdr workspace list)" \
  --argjson tabs "$(herdr tab list)" \
  --argjson panes "$(herdr pane list)" \
  --argjson colors "$token_colors" '
  def rgb($hex): $hex | ltrimstr("#") | ascii_downcase | explode
    | map(if . >= 97 then . - 87 else . - 48 end)
    | "\(.[0] * 16 + .[1]);\(.[2] * 16 + .[3]);\(.[4] * 16 + .[5])";
  def paint($hex): "\u001b[38;2;\(rgb($hex))m\(.)\u001b[0m";
  def dim: "\u001b[2m\(.)\u001b[0m";
  def pad($n): . + (" " * ([$n - length, 0] | max));
  def state:
    {working: "#D29F73", blocked: "#DC9693", done: "#8EABE1", idle: "#89B98A"}[. // ""] as $c
    | if $c then "●" | paint($c) else "○" | dim end;

  ($ws.result.workspaces | map({(.workspace_id): .}) | add) as $workspaces
  | ($panes.result.panes | group_by(.tab_id) | map({(.[0].tab_id): .}) | add) as $by_tab
  | [
      $tabs.result.tabs[]
      | $workspaces[.workspace_id] as $w
      | {
          id: .tab_id,
          status: .agent_status,
          space: $w.label,
          color: ((($w.tokens // {}) | keys | map($colors[.] // empty) | first) // "#BEBEBE"),
          tab: .label,
          agents: ($by_tab[.tab_id] // [] | map(.agent // empty) | unique | join(", "))
        }
    ] as $rows
  | ($rows | map(.space | length) | max) as $space_w
  | ($rows | map(.tab | length) | max) as $tab_w
  | $rows[]
  | . as $r
  | "\($r.id)\t\($r.status | state)  \($r.space | pad($space_w) | paint($r.color))  \($r.tab | pad($tab_w))  \($r.agents | dim)"
')

insert_prompt='› '
nav_prompt='· '

selected=$(
  printf '%s\n' "$rows" |
    fzf --ansi --layout=reverse --height=100% --tiebreak=index \
      --delimiter=$'\t' --with-nth=2 \
      --prompt="$insert_prompt" --pointer='▌' --gutter=' ' --info=inline-right \
      --no-scrollbar --separator='─' \
      --color='bg:-1,bg+:#262626,gutter:-1,fg+:-1,prompt:#8EABE1,pointer:#8EABE1,hl:#D29F73:bold,hl+:#D29F73:bold,info:#606060,separator:#303030' \
      --bind 'tab:down,shift-tab:up' \
      --bind 'start:unbind(j,k,i,/,q)' \
      --bind "esc:transform:[[ \$FZF_PROMPT == '$insert_prompt' ]] && echo 'change-prompt($nav_prompt)+rebind(j,k,i,/,q)' || echo abort" \
      --bind 'j:down,k:up,q:abort' \
      --bind "i:change-prompt($insert_prompt)+unbind(j,k,i,/,q)" \
      --bind "/:change-prompt($insert_prompt)+unbind(j,k,i,/,q)"
) || exit 0

herdr tab focus "${selected%%$'\t'*}" >/dev/null
