#!/bin/sh
# Fresh-install helper: after `git clone` this repo to ~/dotfiles,
# run this to symlink every config back into $HOME.
set -e
REPO="$HOME/dotfiles"

link_one() {
    src="$1"
    dst="$2"
    rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
}

for d in hypr waybar kitty rofi rofimoji Thunar dunst wlogout; do
    link_one "$REPO/.config/$d" "$HOME/.config/$d"
done
link_one "$REPO/.config/rofimoji.rc" "$HOME/.config/rofimoji.rc"

for f in .zshrc .zshrc.pre-oh-my-zsh .bashrc .bash_profile .gtkrc-2.0; do
    link_one "$REPO/$f" "$HOME/$f"
done

echo "Done. Configs linked from $REPO."