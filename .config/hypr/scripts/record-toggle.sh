#!/bin/bash
DIR="$HOME/Videos/Recordings"
FILE="$DIR/$(date +%Y-%m-%d-%H%M%S).mp4"

if pgrep -x wf-recorder > /dev/null; then
    pkill --signal SIGINT wf-recorder
    notify-send -t 2000 "Recording stopped" "Saved to $DIR"
else
    mkdir -p "$DIR"
    GEOM=$(slurp)
    if [ -n "$GEOM" ]; then
        notify-send -t 1500 "Recording started"
        wf-recorder -g "$GEOM" -f "$FILE"
    fi
fi
