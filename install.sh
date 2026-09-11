#!/bin/sh
# Fresh-install helper: after `git clone` this repo to ~/dotfiles,
# run this to symlink every config back into $HOME.
# Optionally: install yay and reinstall all packages from packages.txt.
set -e
REPO="$HOME/dotfiles"

link_one() {
    src="$1"
    dst="$2"
    rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
}

for d in hypr waybar kitty rofi rofimoji Thunar dunst wlogout fastfetch btop gtk-3.0 gtk-4.0 qt5ct qt6ct nwg-look autostart; do
    link_one "$REPO/.config/$d" "$HOME/.config/$d"
done
for f in rofimoji.rc mimeapps.list user-dirs.dirs; do
    link_one "$REPO/.config/$f" "$HOME/.config/$f"
done
link_one "$REPO/.config/VSCodium/User/settings.json" "$HOME/.config/VSCodium/User/settings.json"
link_one "$REPO/.config/VSCodium/User/snippets" "$HOME/.config/VSCodium/User/snippets"
link_one "$REPO/.local/bin/cliphist-rofi-img" "$HOME/.local/bin/cliphist-rofi-img"
link_one "$REPO/.local/bin/emoji-picker" "$HOME/.local/bin/emoji-picker"

link_one "$REPO/Pictures/wallpapers" "$HOME/Pictures/wallpapers"

for f in .zshrc .zshrc.pre-oh-my-zsh .bashrc .bash_profile .gtkrc-2.0 update-system.sh; do
    link_one "$REPO/$f" "$HOME/$f"
done

echo "Configs linked from $REPO."

echo
read -r -p "Install yay + all packages from packages.txt? [y/N] " ans
case "$ans" in
    y|Y|yes)
        if ! command -v yay >/dev/null 2>&1; then
            echo "Installing yay..."
            if ! command -v makepkg >/dev/null 2>&1; then
                sudo pacman -S --needed --noconfirm base-devel git
            fi
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            (cd /tmp/yay && makepkg -si --noconfirm)
        else
            echo "yay already installed."
        fi
        echo "Installing packages from packages.txt (--needed)..."
        yay -S --needed --noconfirm $(cat "$REPO/packages.txt")
        ;;
    *)
        echo "Skipped package install."
        ;;
esac