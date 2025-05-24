#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# NVIM Configs
alias nvkick='NVIM_APPNAME="nvim-kickstart" nvim'
alias nvchad='NVIM_APPNAME="nvchad" nvim'
alias nvquar='NVIM_APPNAME="nvim-quarto" nvim'

# Suspend & Hibernate Shorthand
alias sus='cd | systemctl suspend'
# alias hibernate='systemctl hibernate' # Not in use ATM

# Rank Arch Mirrors
alias arch-mirror-rank="rate-mirrors --disable-comments-in-file --entry-country=CA --protocol=https arch --max-delay 7200 | sudo tee /etc/pacman.d/mirrorlist"

# Starship
eval "$(starship init bash)"


# Created by `pipx` on 2025-02-27 02:19:14
export PATH="$PATH:/home/sudowoodo/.local/bin"
