#!/bin/sh
# Sync dotfiles to GitHub: edit configs normally, then run ./push.sh
set -e
cd "$(dirname "$0")"
git add -A
git commit -m "Update dotfiles" >/dev/null 2>&1 || true
git push
echo "Dotfiles pushed to GitHub."