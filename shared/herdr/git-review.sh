#!/usr/bin/env bash
set -euo pipefail

reviewr_tabs() {
  herdr tab list | jq -r '.result.tabs[] | select(.label == "reviewr") | .tab_id'
}

herdr plugin action invoke toggle --plugin persiyanov.reviewr >/dev/null

for _ in $(seq 30); do
  tabs="$(reviewr_tabs)"
  if [ -n "$tabs" ]; then
    for tab in $tabs; do
      herdr tab rename "$tab" "Git Review" >/dev/null
      herdr tab focus "$tab" >/dev/null
    done
    exit 0
  fi
  sleep 0.1
done
