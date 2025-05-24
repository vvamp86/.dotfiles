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

ln -sf "$DOTFILES_DIR/alacritty/" ~/.config/alacritty/
ln -sf "$DOTFILES_DIR/i3/" ~/.config/i3/
ln -sf "$DOTFILES_DIR/nvim/" ~/.config/nvim/  # or init.vim
ln -sf "$DOTFILES_DIR/picom/" ~/.config/picom/
ln -sf "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml
ln -sf "$HOME/.bashrc" ~/.config/.bashrc

echo -e "${GREEN}Setup complete.${NC}"
