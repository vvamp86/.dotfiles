#!/bin/bash

set -e  # Exit on error

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}==> Removing dotfile symlinks...${NC}"

remove_symlink() {
    local target=$1
    if [ -L "$target" ]; then
        rm "$target"
        echo "Removed symlink: $target"
    else
        echo "Skipped (not a symlink): $target"
    fi
}

remove_symlink ~/.config/alacritty/alacritty.yml
remove_symlink ~/.config/i3/config
remove_symlink ~/.config/nvim/init.lua
remove_symlink ~/.config/picom/picom.conf
remove_symlink ~/.config/starship.toml

echo -e "${GREEN}✅ Uninstallation complete.${NC}"

