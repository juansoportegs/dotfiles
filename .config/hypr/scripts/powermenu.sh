#!/bin/bash
chosen=$(printf "Shutdown\0icon\x1fsystem-shutdown\nReboot\0icon\x1fsystem-reboot\nLogout\0icon\x1fsystem-log-out\nLock\0icon\x1fsystem-lock-screen" | rofi -dmenu -p "Power" -show-icons -theme-str 'window {width: 28%;} inputbar {enabled: false;} listview {columns: 4; lines: 1;}')

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot)   systemctl reboot ;;
    Logout) loginctl terminate-user "$USER" ;;
    Lock)     hyprlock ;;
esac
