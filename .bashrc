#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Depreciated NVIM Configs
# alias nvkick='NVIM_APPNAME="nvim-kickstart" nvim'
# alias nvchad='NVIM_APPNAME="nvchad" nvim'
# alias nvquar='NVIM_APPNAME="nvim-quarto" nvim'

# Suspend & Hibernate Shorthand
alias sus='cd | systemctl suspend'
alias hib='systemctl hibernate'

# Rank Arch Mirrors
alias arch-mirror-rank="rate-mirrors --disable-comments-in-file --entry-country=CA --protocol=https arch --max-delay 7200 | sudo tee /etc/pacman.d/mirrorlist"

# Starship
eval "$(starship init bash)"

alias dc='exec xmodmap -e "clear lock" && exec xmodmap -e "keysym Caps_Lock = Escape"'
