#!/bin/bash

yay -S discord_arch_electron obsidian cloudflare-warp-bin proton-vpn-gtk-app brave-bin spotify-adblock timeshift quickemu

sudo pacman -S fwupd blueman rate-mirrors keepassxc qemu-full easyeffects calf lsp-plugins-lv2 zam-plugins-lv2 mda.lv2 clamav

# enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# enable cloudflare-warp
sudo systemctl start warp-svc
sudo systemctl enable warp-svc
warp-cli registration new
warp-cli connect

# enable proton-vpn
# don't know how to lol
