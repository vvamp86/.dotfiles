#!/bin/bash

############################
### Some default options ###
############################
set -euo pipefail  # Exit on any error

GREEN='\033[0;32m'
NC='\033[0m'

print_step() {
  echo -e "${GREEN}==> $1...${NC}"
}

###########################
### Confirm paru exists ###
###########################
if ! command -v paru &> /dev/null; then
  print_step "Installing paru (AUR helper)"
  sudo pacman -S --needed --noconfirm paru
fi

#########################
### Download Packages ###
#########################
### Pacman Packages
print_step "Installing pacman packages"
sudo pacman -Syu --needed --noconfirm \
  alacritty i3-wm neovim picom starship git \
  ttf-firacode-nerd xclip dunst brightnessctl flameshot \
  fwupd blueman rate-mirrors keepassxc qemu-full \
  easyeffects calf lsp-plugins-lv2 zam-plugins-lv2 mda.lv2 \
  clamav tmux feh yazi btop bat eza remake nftables \
  procs tldr fd duf dust zoxide fprintd \
  zathura zathura-pdf-mupdf lightdm lightdm-gtk-greeter \
  xdotools fcitx5

### AUR Packages
print_step "Installing AUR packages"
paru -S --needed \
  gruvbox-material-gtk-theme-git \
  gruvbox-material-icon-theme-git \
  xcursor-simp1e-gruvbox-dark \
  discord_arch_electron obsidian cloudflare-warp-bin \
  proton-vpn-gtk-app brave-bin spotify-adblock \
  timeshift quickemu i3lock-color texlive-binextra \
  autotiling r unipicker

#######################
### Enable Services ###
#######################
print_step "Enabling optional services..."

### Bluetooth
read -p "Enable Bluetooth? [y/N]: " enable_bt
if [[ "$enable_bt" == [yY] ]]; then
  print_step "Enabling Bluetooth"
  sudo systemctl enable --now bluetooth
fi

### Cloudflare Warp
read -p "Enable Cloudflare Warp? [y/N]: " enable_warp
if [[ "$enable_warp" == [yY] ]]; then
  print_step "Enabling Cloudflare Warp"
  sudo systemctl enable --now warp-svc
  warp-cli registration new
  warp-cli connect
fi

### ProtonVPN
# Unimplemented

### ClamAV
read -p "Enable ClamAV? [y/N]: " enable_clamav
if [[ "$enable_clamav" == [yY] ]]; then
  print_step "Enabling ClamAV"
  sudo freshclam
  sudo systemctl enable --now clamav-daemon.service
fi

######################
### Enable Devices ###
######################

### Fingerprint Registration
# read -p "Enable fingerprint reader? [y/N]: " enable_fprintd
# if [[ "$enable_fprintd" == [yY] ]]; then
#   fprintd-delete "$USER"
#   for finger in {left,right}-{thumb,{index,middle,ring,little}-finger}; do
#     fprintd-enroll -f "$finger" "$USER";
#   done
# fi

read -p "Use fcitx5? [y/N]: " fcitx_enable
if [[ "$fcitx_enable" == [yY] ]]; then
  systemctl --user enable fcitx5
  systemctl --user start fcitx5
  echo -e "\e[1;31mPlease Install Languages On Your Own\e[0m"
fi

##################
### Symlinking ###
##################

read -p "Auto Symlink? [y/N]: " symlinked
if [[ "$symlinked" == [yY] ]]; then
  ##########################################
  ### Remove Existing Config Directories ###
  ##########################################
  print_step "Removing existing config directories"

  # NOTE: INSERT CONFIGS in `.config` HERE
  CONFIGS=(alacritty i3 nvim picom dunst rofi gtk-3.0 gtk-4.0 flameshot yazi starship.toml)

  for config in "${CONFIGS[@]}"; do
    rm -rf "$HOME/.config/$config"
  done

  # NOTE: INSERT CONFIGS IN `~` HERE
  rm -f ~/.bashrc ~/.profile ~/.Xresources ~/.gtkrc-2.0 ~/.tmux.conf

  ########################
  ### Begin Symlinking ###
  ########################
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
    [~/.config/yazi]=$DOTFILES/yazi
    [~/.config/zathura]=$DOTFILES/zathura
    [~/.config/starship.toml]=$DOTFILES/starship.toml
    [~/.gtkrc-2.0]=$DOTFILES/.gtkrc-2.0
    [~/.bashrc]=$DOTFILES/.bashrc
    [~/.profile]=$DOTFILES/.profile
    [~/.Xresources]=$DOTFILES/.Xresources
    [~/.tmux.conf]=$DOTFILES/.tmux.conf
  )

  for target in "${!SYMLINKS[@]}"; do
    ln -sfn "${SYMLINKS[$target]}" "${target/#\~/$HOME}"
  done
fi

###################
### Update Grub ###
###################
read -p "Change Grub Bootloader? [y/N]: " grub_change
if [[ "$grub_change" == [yY] ]]; then
  print_step "Changing Grub"
  sudo cp -r ~/.dotfiles/grub/grub /etc/default/grub
  sudo cp -r ~/.dotfiles/grub/grub-theme /boot/grub/themes/grub-theme
  sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

######################
### Update LightDM ###
######################

read -p "Update LightDM? [y/N]: " lightdm_change
if [[ "$lightdm_change" == [yY] ]]; then
  print_step "Creating Blurred Background Image"
  PICTURE="/usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png"
  OUTPUT="/usr/share/endeavouros/backgrounds/endeavouros-wallpaper-blur.png"
  BLUR="5x4"

  sudo magick "$PICTURE" -blur "$BLUR" \( -size $(identify -format "%wx%h" "$PICTURE") xc:'rgba(0,0,0,0.5)' \) \
-compose over -composite "$OUTPUT"

  sudo rm -rf /etc/lightdm
  sudo cp -r ~/.dotfiles/lightdm /etc/lightdm
fi

#############################
### Successful Completion ###
#############################
print_step "Setup complete"
