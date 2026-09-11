#!/bin/bash
inotifywait -m -e close_write,moved_to,create \
  "$HOME/.config/waybar/config.jsonc" \
  "$HOME/.config/waybar/style.css" 2>/dev/null | while read; do
  killall -SIGUSR2 waybar
done
