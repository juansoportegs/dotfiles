#!/usr/bin/env bash

set -euo pipefail

WPDIR="$HOME/Pictures/wallpapers"
SYMLINK="$HOME/.config/hypr/scripts/current_wallpaper"
MONITORS=("DP-2" "DP-1")
INTERVAL=600

sleep 3

while true; do
    mapfile -t wallpapers < <(find "$WPDIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \))

    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "$(date): No wallpapers found in $WPDIR" >&2
        sleep "$INTERVAL"
        continue
    fi

    for mon in "${MONITORS[@]}"; do
        wp="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

        awww img "$wp" \
            --outputs "$mon" \
            --transition-type random \
            --transition-duration 2
    done

    ln -sfn "$wp" "$SYMLINK"

    sleep "$INTERVAL"
done