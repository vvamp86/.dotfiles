#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1='[\u@\h \W]\$ ' # Legacy

# Starship
eval "$(starship init bash)"

# Zoxide
eval "$(zoxide init bash)"

###########
# Exports #
###########

# Export Nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

# set GTK2
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# man page customization
export MANPAGER="nvim +Man!"

# terminal environment
export TERMINAL=alacritty

# rofi export
export MENU='rofi -dmenu -theme mytheme -config ~/.config/rofi/config.rasi'

########################
# Replacement Commands #
########################
alias cat='bat'
alias make='remake'
alias ls='eza'
alias grep='rg'     # ripgrep
alias yay='paru'    # paru for efficiency

alias du='dust'
alias df='duf'
alias find='fd'
alias ps='procs'
alias cd='z'        # zoxide
alias top='btop'

##############
# Shorthands #
##############

# nvim shortcut
# alias nvchad='NVIM_APPNAME="nvchad" nvim' # Old shortcut
alias nv='nvim'

# yazi shortcut
alias yz="yazi"

# Suspend & Hibernate Shorthand
alias sus='cd | systemctl suspend'
# alias hib='cd | systemctl hibernate'  # Not in use

# Rank Arch Mirrors
alias arch-mirror-rank="rate-mirrors --disable-comments-in-file --entry-country=CA --protocol=https arch --max-delay 7200 | sudo tee /etc/pacman.d/mirrorlist"

# Lazy dumb git function
function acp() {
    git add .
    git commit -a -m "$1"
    git push
}

# Remove caps lock and replae it with escape
alias dc='exec xmodmap -e "clear lock" | exec xmodmap -e "keysym Caps_Lock = Escape"'
