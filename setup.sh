#!/bin/bash

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Installing dependencies...${NC}"
sudo pacman -Syu --noconfirm alacritty i3-wm neovim picom starship git ttf-firacode-nerd

echo -e "${GREEN}==> Removing existing config directories...${NC}"
rm -rf ~/.config/alacritty ~/.config/i3 ~/.config/nvim ~/.config/picom

echo -e "${GREEN}==> Symlinking dotfiles...${NC}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn ~/.dotfiles/picom ~/.config/picom
ln -sfn ~/.dotfiles/i3 ~/.config/i3
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
ln -sfn ~/.dotfiles/picom ~/.config/picom
ln -sfn ~/.dotfiles/starship.toml ~/.config/starship.toml
ln -sfn ~/.dotfiles/.bashrc ~/.bashrc

echo -e "${GREEN}Setup complete.${NC}"
