#!/bin/bash

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Installing dependencies...${NC}"
sudo pacman -Syu --noconfirm alacritty i3-wm neovim picom starship git

echo -e "${GREEN}==> Creating config directories...${NC}"
mkdir -p ~/.config/alacritty ~/.config/i3 ~/.config/nvim ~/.config/picom

echo -e "${GREEN}==> Symlinking dotfiles...${NC}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$DOTFILES_DIR/alacritty/alacritty.yml" ~/.config/alacritty/alacritty.yml
ln -sf "$DOTFILES_DIR/i3/config" ~/.config/i3/config
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua  # or init.vim
ln -sf "$DOTFILES_DIR/picom/picom.conf" ~/.config/picom/picom.conf
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml

echo -e "${GREEN}==> Starship configuration...${NC}"
echo 'eval "$(starship init bash)"' >> ~/.bashrc  # Or ~/.zshrc

echo -e "${GREEN}Setup complete.${NC}"
