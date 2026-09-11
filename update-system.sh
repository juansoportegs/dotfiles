#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run as root: sudo bash $0"
    exit 1
fi

echo "=== Reordering repository priorities ==="

cp /etc/pacman.conf /etc/pacman.conf.bak

python3 -c "
import re

with open('/etc/pacman.conf', 'r') as f:
    content = f.read()

lines = content.split('\n')
sections = {}
current_section = 'header'
current_lines = []

for line in lines:
    m = re.match(r'^\[(.+)\]', line.strip())
    if m:
        sections[current_section] = '\n'.join(current_lines)
        current_section = m.group(1).lower()
        current_lines = [line]
    else:
        current_lines.append(line)
sections[current_section] = '\n'.join(current_lines)

order = []
for key in ['header', 'options', 'core', 'extra', 'multilib']:
    if key in sections:
        order.append(key)
for key in sections:
    if 'cachy' in key and key not in order:
        order.append(key)
for key in sections:
    if 'chaotic' in key and key not in order:
        order.append(key)
for key in sections:
    if key not in order:
        order.append(key)

result = '\n\n'.join(sections[k] for k in order if k in sections) + '\n'

with open('/etc/pacman.conf', 'w') as f:
    f.write(result)

print('Done. Repository order:')
for k in order:
    if k in sections:
        print(f'  - {k}')
"

echo ""
echo "=== Syncing pacman databases ==="
pacman -Syy

echo ""
echo "=== Upgrading system ==="
pacman -Syu --noconfirm

echo ""
echo "=== Removing hyprutils-git and installing hyprutils ==="
pacman -Rns hyprutils-git --noconfirm 2>/dev/null || echo "hyprutils-git not installed, skipping removal"
pacman -S hyprutils --noconfirm

echo ""
echo "=== Done ==="
echo "Backup saved at /etc/pacman.conf.bak"
