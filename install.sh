#!/bin/sh
# Fresh-install helper: after `git clone` this repo to ~/dotfiles,
# run this to symlink every config back into $HOME.
#
# Usage:
#   ./install.sh             # symlink configs only (safe, no-op if re-run)
#   ./install.sh --full      # symlink configs + CachyOS/Chaotic repos + yay + all packages
#   ./install.sh --packages  # package step only (repos + yay + packages.txt)
#
# NOTE: --full/--packages are for a FRESH system. On an existing install
# the package step re-resolves every package against repo priority, which
# downgrades Chaotic-AUR (-1.1 pkgrel) and CachyOS builds to stock Arch.
set -e
REPO="$HOME/dotfiles"

DO_SYMLINK=0
DO_PACKAGES=0
if [ "$#" -eq 0 ]; then
    DO_SYMLINK=1
fi
for arg in "$@"; do
    case "$arg" in
        --full) DO_SYMLINK=1; DO_PACKAGES=1 ;;
        --packages) DO_PACKAGES=1 ;;
        *) echo "Unknown option: $arg (use --full or --packages)" >&2; exit 1 ;;
    esac
done

link_one() {
    src="$1"
    dst="$2"
    rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
}

if [ "$DO_SYMLINK" -eq 1 ]; then
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
fi

setup_cachyos() {
    if grep -qE '^[[:space:]]*\[cachyos' /etc/pacman.conf 2>/dev/null; then
        echo "CachyOS repos already configured."
        return 0
    fi
    echo "Adding CachyOS repositories (auto-detects CPU) - kernel/prebuilt binaries become available..."
    cd /tmp || exit 1
    curl -L https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
    tar xf cachyos-repo.tar.xz
    (cd cachyos-repo && yes | sudo ./cachyos-repo.sh)
}

setup_chaotic() {
    if grep -q '^\[chaotic-aur\]' /etc/pacman.conf 2>/dev/null; then
        echo "Chaotic-AUR already configured."
        return 0
    fi
    # Verified 2026-09: the current chaotic-keyring/mirrorlist pkg.zip files
    # are signed with key BFB13EA507EFDADB64A944813A40CB5E7E5CBC30 (NOT the
    # old FBA220DFC880C036 that some guides still paste).
    KEY="BFB13EA507EFDADB64A944813A40CB5E7E5CBC30"
    echo "Adding Chaotic-AUR repository (key $KEY)..."
    for ks in "keyserver.ubuntu.com" "hkps://keys.openpgp.org"; do
        if sudo pacman-key --recv-key "$KEY" --keyserver "$ks"; then
            break
        fi
    done
    sudo pacman-key --lsign-key "$KEY"
    sudo pacman -U --noconfirm \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    printf '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' | sudo tee -a /etc/pacman.conf >/dev/null
}

if [ "$DO_PACKAGES" -eq 1 ]; then
    echo "Installing packages (fresh-system mode)..."
    echo "> Setting up CachyOS + Chaotic-AUR repos so kernels and binaries come PREBUILT (no AUR compilation)..."
    setup_cachyos
    setup_chaotic
    echo "> Full system upgrade to prebuilt CachyOS packages..."
    sudo pacman -Syu --noconfirm
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
    echo "> Clearing conflicting JACK stacks so pipewire-jack can replace them..."
    for p in jack jack2 jack-dbus jack2-dbus pipewire-jack lib32-jack lib32-jack2 lib32-pipewire-jack; do
        if pacman -Q "$p" >/dev/null 2>&1; then
            echo "  removing $p"
            sudo pacman -Rdd --noconfirm "$p" || true
        fi
    done
    yay -S --needed --noconfirm $(cat "$REPO/packages.txt")
fi