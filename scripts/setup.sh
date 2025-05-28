#!/bin/bash

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Installing dependencies...${NC}"
sudo pacman -Syu --needed alacritty i3-wm neovim picom starship git ttf-firacode-nerd xclip dunst brightnessctl xfce4-screenshooter

yay -Syu --needed gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git xcursor-simp1e-gruvbox-dark

echo -e "${GREEN}==> Removing existing config directories...${NC}"
rm -rf ~/.config/alacritty ~/.config/i3 ~/.config/nvim ~/.config/picom ~/.config/gtk-3.0 ~/.config/gtk-4.0 ~/.bashrc ~/.profile ~/.config/dunst ~/.config/rofi

echo -e "${GREEN}==> Symlinking dotfiles...${NC}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn ~/.dotfiles/picom ~/.config/picom
ln -sfn ~/.dotfiles/i3 ~/.config/i3
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
ln -sfn ~/.dotfiles/alacritty/ ~/.config/alacritty
ln -sfn ~/.dotfiles/picom ~/.config/picom
ln -sfn ~/.dotfiles/starship.toml ~/.config/starship.toml
ln -sfn ~/.dotfiles/gtk-3.0 ~/.config/gtk-3.0
ln -sfn ~/.dotfiles/gtk-4.0 ~/.config/gtk-4.0
ln -sfn ~/.dotfiles/.bashrc ~/.bashrc
ln -sfn ~/.dotfiles/.profile ~/.profile
ln -sfn ~/.dotfiles/dunst ~/.config/dunst
ln -sfn ~/.dotfiles/rofi ~/.config/rofi

echo -e "${GREEN}Setup complete.${NCa}"
