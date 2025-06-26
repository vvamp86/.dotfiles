# Dotfiles for Arch Linux Appearance
Meant to install after installing EndeavourOS i3wm. Based off & inspired by endeavouros-i3wm-setup, kickstart.nvim, nvchad, and the gruvbox colorscheme.

Mostly sane presets with a heavy, ***heavy*** tilt towards vi motions. ❤️
    Also a tilt towards *slightly* more efficient options

Run the following after cloning this repository:
```Bash
cd ~/.dotfiles/scripts
./full_install.sh
```
# Note: Brave Settings
Must be manual:
- toggle (Use GTK) for theme in [appearance](brave://settings/appearance)
- install [Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)
- install "Gruvbox Dark Everywhere - Global Dark Style"
- enable the style

# Things to Include:
- battery manager
- control manager
- nvim keyboard
- perpetual capslock -> escape
- nvim for Latex, R, & Obsidian
- plover stenography
- customize bootloader (partially completed)
    - add a way to choose screen size in full_setup.sh script to fix this
- straighten X11 and have options to switch to wayland
- get scrolling artifacts fixed
- setup simlinker to gnu stow for convenience (this is really easy, I'm just lazy)
- add vesktop & plymouth to the full_setup.sh script
- add a way to choose wallpaper in full_setup.sh script
- nvim efficiencies needed:
    - vertical selection like in SQL / R Studio
    - Vimtex concealer / auto replacement with unicode characters
    - Latex Suite Shorthands in vimtex
    - html rendering
    - paste relative to indentation
    - latex to unicode
- keep currently opened applications as cache as a list after reboot / restart for simple continuation
    - maybe tmux equivalent with resurrect?
