#!/bin/bash

set -euo pipefail  # Exit on any error

GREEN='\033[0;32m'
NC='\033[0m'

print_step() {
  echo -e "${GREEN}==> $1...${NC}"
}

### Confirm paru exists
if ! command -v paru &> /dev/null; then
  print_step "Installing paru (AUR helper)"
  sudo pacman -S --needed --noconfirm paru
fi

### Pacman Packages
print_step "Installing pacman dependencies"
sudo pacman -Syu --needed --noconfirm \
  alacritty i3-wm neovim picom starship git \
  ttf-firacode-nerd xclip dunst brightnessctl flameshot \
  fwupd blueman rate-mirrors keepassxc qemu-full \
  easyeffects calf lsp-plugins-lv2 zam-plugins-lv2 mda.lv2 \
  clamav tmux feh

### AUR Packages
print_step "Installing AUR packages"
yay -S --needed \
  gruvbox-material-gtk-theme-git \
  gruvbox-material-icon-theme-git \
  xcursor-simp1e-gruvbox-dark \
  discord_arch_electron obsidian cloudflare-warp-bin \
  proton-vpn-gtk-app brave-bin spotify-adblock \
  timeshift quickemu i3lock-color texlive-binextra \
  autotiling tmux-plugin-manager

### Enable Services
print_step "Enabling optional services..."

# Bluetooth
read -p "Enable Bluetooth? [y/N]: " enable_bt
if [[ "$enable_bt" == [yY] ]]; then
  print_step "Enabling Bluetooth"
  sudo systemctl enable --now bluetooth
fi

# Cloudflare Warp
read -p "Enable Cloudflare Warp? [y/N]: " enable_warp
if [[ "$enable_warp" == [yY] ]]; then
  print_step "Enabling Cloudflare Warp"
  sudo systemctl enable --now warp-svc
  warp-cli registration new
  warp-cli connect
fi

# ProtonVPN
# Unimplemented

# ClamAV
# Unimplemented

### Remove Existing Directories for Symlinking
print_step "Removing existing config directories"

# NOTE: INSERT CONFIGS in `.config` HERE
CONFIGS=(alacritty i3 nvim picom dunst rofi gtk-3.0 gtk-4.0 flameshot)

for config in "${CONFIGS[@]}"; do
  rm -rf "$HOME/.config/$config"
done

# NOTE: INSERT CONFIGS IN `~` HERE
rm -f ~/.bashrc ~/.profile ~/.Xresources ~/.gtkrc-2.0 ~/.tmux.conf

### Start Symlinking Dotfiles
print_step "Symlinking dotfiles"
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# NOTE: INSERT CONFIGS IN THIS MANNER:
# `[SYMLINK LOCATION]=DOTFILES/name_of_folder`
declare -A SYMLINKS=(
  [~/.config/alacritty]=$DOTFILES/alacritty
  [~/.config/i3]=$DOTFILES/i3
  [~/.config/nvim]=$DOTFILES/nvim
  [~/.config/picom]=$DOTFILES/picom
  [~/.config/dunst]=$DOTFILES/dunst
  [~/.config/rofi]=$DOTFILES/rofi
  [~/.config/gtk-3.0]=$DOTFILES/gtk-3.0
  [~/.config/gtk-4.0]=$DOTFILES/gtk-4.0
  [~/.config/flameshot]=$DOTFILES/flameshot
  [~/.config/starship.toml]=$DOTFILES/starship.toml
  [~/.gtkrc-2.0]=$DOTFILES/gtkrc-2.0
  [~/.bashrc]=$DOTFILES/.bashrc
  [~/.profile]=$DOTFILES/.profile
  [~/.Xresources]=$DOTFILES/.Xresources
  [~/.tmux.conf]=$DOTFILES/.tmux.conf
)

for target in "${!SYMLINKS[@]}"; do
  ln -sfn "${SYMLINKS[$target]}" "${target/#\~/$HOME}"
done

### Successful Completion
print_step "Setup complete"
