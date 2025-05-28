#!/bin/bash

set -e  # Exit on any error

GREEN='\033[0;32m'
NC='\033[0m'

### Pacman Packages
echo -e "${GREEN}==> Installing pacman dependencies...${NC}"
sudo pacman --needed -Syu --noconfirm \
  alacritty i3-wm neovim picom starship git \
  ttf-firacode-nerd xclip dunst brightnessctl flameshot \
  fwupd blueman rate-mirrors keepassxc qemu-full \
  easyeffects calf lsp-plugins-lv2 zam-plugins-lv2 mda.lv2 \
  clamav

### AUR Packages
echo -e "${GREEN}==> Installing yay (AUR) packages...${NC}"
yay -S --needed \
  gruvbox-material-gtk-theme-git \
  gruvbox-material-icon-theme-git \
  xcursor-simp1e-gruvbox-dark \
  discord_arch_electron obsidian cloudflare-warp-bin \
  proton-vpn-gtk-app brave-bin spotify-adblock \
  timeshift quickemu i3lock-color texlive-binextra

### Enable Services
echo -e "${GREEN}==> Enabling services...${NC}"
# Bluetooth
sudo systemctl enable --now bluetooth

# Cloudflare Warp
sudo systemctl enable --now warp-svc
warp-cli registration new
warp-cli connect

# ProtonVPN
#

### Remove Existing Directories for Symlinking
echo -e "${GREEN}==> Removing existing config directories...${NC}"
CONFIGS=(alacritty i3 nvim picom dunst rofi gtk-3.0 gtk-4.0 flameshot)
for config in "${CONFIGS[@]}"; do
  rm -rf "$HOME/.config/$config"
done
rm -f ~/.bashrc ~/.profile ~/.Xresources ~/.gtkrc-2.0

### Start Symlinking Dotfiles
echo -e "${GREEN}==> Symlinking dotfiles...${NC}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A SYMLINKS=(
  [~/.config/alacritty]=$DOTFILES_DIR/alacritty
  [~/.config/i3]=$DOTFILES_DIR/i3
  [~/.config/nvim]=$DOTFILES_DIR/nvim
  [~/.config/picom]=$DOTFILES_DIR/picom
  [~/.config/dunst]=$DOTFILES_DIR/dunst
  [~/.config/rofi]=$DOTFILES_DIR/rofi
  [~/.config/gtk-3.0]=$DOTFILES_DIR/gtk-3.0
  [~/.config/gtk-4.0]=$DOTFILES_DIR/gtk-4.0
  [~/.config/flameshot]=$DOTFILES_DIR/flameshot
  [~/.config/starship.toml]=$DOTFILES_DIR/starship.toml
  [~/.gtkrc-2.0]=$DOTFILES_DIR/gtkrc-2.0
  [~/.bashrc]=$DOTFILES_DIR/.bashrc
  [~/.profile]=$DOTFILES_DIR/.profile
  [~/.Xresources]=$DOTFILES_DIR/.Xresources
)

for target in "${!SYMLINKS[@]}"; do
  ln -sfn "${SYMLINKS[$target]}" "${target/#\~/$HOME}"
done

### Successful Completion
echo -e "${GREEN}==> Setup complete.${NC}"
