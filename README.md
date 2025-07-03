# Dotfiles for Arch Linux Appearance
Meant to install after installing EndeavourOS i3wm. Based off & inspired by endeavouros-i3wm-setup, kickstart.nvim, nvchad, and the gruvbox colorscheme.

Mostly sane presets with a heavy, ***heavy*** tilt towards vi motions. ❤️
    Also a tilt towards *slightly* more efficient options

Run the following after cloning this repository:
```Bash
cd ~/.dotfiles/scripts
./full_install.sh
```

NOTE:
- this is currently all x11, there are issues but they aren't severe enough to address immediately
- this repo will gradually move towards wayland, but that will take time, likely far in the future

# Note: Brave Settings
Must be manual:
- toggle (Use GTK) for theme in [appearance](brave://settings/appearance)
- install [Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)
- install "Gruvbox Dark Everywhere - Global Dark Style"
- enable the style

# Note: Local Obsidian Nvim File
Manual currently for security reasons:
- make a file in .dotfiles/nvim/lua/config/ called obsidian_local.lua
- Insert the following
```lua
return {
  vault_path = '~/path/to/value',
}
```
- then obsidian.nvim will detect properly :D

# Things to Include:
- battery manager
- control manager
- nvim keyboard
- nvim for Latex, R, & Obsidian
- plover stenography
- customize bootloader (partially completed)
    - add a way to choose screen size in full_setup.sh script to fix this
- straighten X11 and have options to switch to wayland
    - There's a lot to be changed in i3wm config to sway defaults
    - workspace maanger change
    - get bluetooth working & get workarounds for other tray icons
    - rofi -> wofi
    - xclip -> wl-clipboard
    - xdotool -> prob swaymsg scripts
    - feh -> swayimg
    - lightdm-gtk-greeter & lightdm  -> greetd & gtkgreet
    - i3lock-color - swaylock-effects
    - picom deleted as it is useless
    - autotiling deleted as it is built in
    - consider replacing the remainder of xfce tools
- get scrolling artifacts fixed
- nvim efficiencies needed:
    - Vimtex concealer / auto replacement with unicode characters
    - Latex Suite Shorthands in vimtex
    - html rendering
    - paste relative to indentation
    - latex to unicode
    - luasnips for latex
- keep currently opened applications as cache as a list after reboot / restart for simple continuation
    - maybe tmux equivalent with resurrect?
