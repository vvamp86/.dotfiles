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

###############################################################################
print_step "Initial Important Installs"

###########################
### Confirm paru exists ###
###########################
if ! command -v paru &> /dev/null; then
  print_step "Installing \`paru\` (AUR helper)"
  sudo pacman -S --needed --noconfirm paru
fi

#########################
### Download Packages ###
#########################
### Pacman Packages
read -p "Download all Packages? [y/N]: " download
if [[ "$download" == [yY] ]]; then
  print_step "Installing pacman packages"
  sudo pacman -Syu --needed --noconfirm \
    sway              \
    swaybg            \
    waybar            \
    \
    alacritty         \
    neovim            \
    starship          \
    git               \
    ttf-firacode-nerd \
    qemu-full         \
    fwupd             \
    pcmanfm           \
    greetd            \
    greetd-tuigreet   \
    plymouth          \
    brightnessctl     \
    blueman           \
    rate-mirrors      \
    keepassxc         \
    \
    easyeffects       \
    calf              \
    lsp-plugins-lv2   \
    zam-plugins-lv2   \
    mda.lv2           \
    \
    clamav            \
    tmux              \
    \
    yazi              \
    btop              \
    bat               \
    eza               \
    remake            \
    nftables          \
    procs             \
    tldr              \
    fd                \
    duf               \
    dust              \
    zoxide            \
    fprintd           \
    zathura           \
    zathura-pdf-mupdf \
    fcitx5-im         \
    stow              \
    myrepos           \
    qt5ct             \
    qt6ct             \
    kvantum           \
    kvantum-qt5       \
    rofi              \
    mako              \
    wl-clipboard      \
    cliphist          \
    grim              \
    slurp             \
    satty             \
    \
    opam              \
    nvm
#   cava # cool audio visualizer, not necessary

  ### AUR Packages
  print_step "Installing AUR packages"
  paru -S --needed                  \
    quickemu                        \
    timeshift                       \
    gruvbox-material-gtk-theme-git  \
    gruvbox-material-icon-theme-git \
    kvantum-theme-gruvbox-git       \
    xcursor-simp1e-gruvbox-dark     \
    interception-tools              \
    interception-caps2esc           \
    cloudflare-warp-bin             \
    proton-vpn-gtk-app              \
    autotiling                      \
    swaylock-effects-git            \
    vencord-bin                     \
    obsidian                        \
    brave-bin                       \
    spotify-adblock                 \
    spicetify-cli                   \
    swaylock-effects                \
    tmux-plugin-manager             \
    texlive-full                    \
    python-pylatexenc               \
    unipicker                       \
    r
fi

###########################
### Wallpaper Choice :D ###
###########################

./wallpaper_selector.sh

#######################
### Enable Services ###
#######################
print_step "Optional services"

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

### Interception-Tools: caps2esc
read -p "Enable Interception Tools for caps2esc? [y/N] " enable_interception
if [[ "$enable_interception" == [yY] ]]; then
  sudo cp $HOME/.dotfiles/boot-stuff/interception-tools/udevmon.yaml /etc/interception
  sudo systemctl enable --now udevmon.service
fi

######################
### Enable Devices ###
######################

### fcitx5
read -p "Enable fcitx5? [y/N]: " fcitx_enable
if [[ "$fcitx_enable" == [yY] ]]; then
  systemctl --user enable fcitx5
  systemctl --user start fcitx5
  echo -e "\e[1;31mPlease Install Languages On Your Own\e[0m"
fi

### Fingerprint Registration
# read -p "Enable fingerprint reader? [y/N]: " enable_fprintd
# if [[ "$enable_fprintd" == [yY] ]]; then
#   fprintd-delete "$USER"
#   for finger in {left,right}-{thumb,{index,middle,ring,little}-finger}; do
#     fprintd-enroll -f "$finger" "$USER";
#   done
# fi

###############################################################################
print_step "Symlinking and Config Options"

##################
### Stow Setup ###
##################

read -p "Auto Symlink with GNU Stow? [y/N]: " symlinked
if [[ "$symlinked" == [yY] ]]; then
  print_step "Symlinking with stow"

  DOTFILES="$HOME/.dotfiles/"

  # Clean up existing conflicting files/directories if needed
  print_step "Removing existing dotfiles to prevent conflict"
  CONFIGS=(alacritty btop gtk-3.0 gtk-4.0 kanshi Kvantum mako nvim qt5ct qt6ct rofi spicetify vesktop sway swaylock waybar yazi zathura)
  FILES=(.bashrc .profile .Xresources .gtkrc-2.0 .tmux.conf .xprofile .config/starship.toml .config/vesktop/themes/gruvbox-material-dark.theme.css )

  for config in "${CONFIGS[@]}"; do
    rm -rf "$HOME/.config/$config"
  done

  for file in "${FILES[@]}"; do
    rm -f "$HOME/$file"
  done

  # Run stow from within the home-dir folder
  cd "$DOTFILES"
  stow --target="$HOME" home-dir
fi

#########################
### Setup img2clip.sh ###
#########################
read -p "Get dependencies for img2clip.sh? [y/N]: " itc
if [[ "$itc" == [yY] ]]; then
  pipx install pix2text
  paru -S --needed                  \
    tesseract                       \
    tesseract-data-eng              \
    caca-utils
fi

########################
### Spicetify Update ###
########################
read -p "Update Spotify Appearance with Spicetify? (must login in spotify first) [y/N]: " spicetify
if [[ "$spicetify" == [yY] ]]; then
  sudo chmod a+wr /opt/spotify
  sudo chmod -R a+wr /opt/spotify/Apps
  spicetify backup apply
  sudo chmod a-w /opt/spotify
  sudo chmod -R a-w /opt/spotify/Apps
fi

###############################################################################
print_step "Boot Appearance Options"

###################
### Update Grub ###
###################
read -p "Change Grub Bootloader? [y/N]: " grub_change
if [[ "$grub_change" == [yY] ]]; then
  print_step "Changing Grub"
  sudo cp -r ~/.dotfiles/boot-stuff/grub/grub /etc/default/grub
  sudo cp -r ~/.dotfiles/boot-stuff/grub/grub-theme /boot/grub/themes/grub-theme
  sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

######################
### Plymouth Setup ###
######################
read -p "Install Plymouth Splash? [y/N]: " plymouth_splash
if [[ "$plymouth_splash" == [yY] ]]; then
  sudo cp -r ~/.dotfiles/boot-stuff/plymouth/gruvbox-overlay /usr/share/plymouth/themes/
  sudo plymouth-set-default-theme gruvbox-overlay
  sudo dracut --regenerate-all --force
fi

######################
### Update LightDM ###
######################

read -p "Update LightDM? [y/N]: " lightdm_change
if [[ "$lightdm_change" == [yY] ]]; then
  sudo rm -rf /etc/lightdm
  sudo cp -r ~/.dotfiles/boot-stuff/lightdm /etc/lightdm
fi

#############################
### Successful Completion ###
#############################
echo -e "${GREEN}Setup Completed!${NC}"
