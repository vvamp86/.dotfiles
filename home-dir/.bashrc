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

# Export Brave as default browser
export BROWSER=brave

# set GTK2
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# man page customization
export MANPAGER="nvim +Man!"

# terminal environment
export TERMINAL=alacritty

# rofi export
export MENU='rofi -dmenu -theme mytheme -config ~/.config/rofi/config.rasi'

# keyboard exports
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx # GLFW works better with ibus but can try fcitx

# For `pipx`
export PATH="$PATH:/home/sudowoodo/.local/bin"

# for `nvm` (nodejs version manager)
source /usr/share/nvm/init-nvm.sh

# for Anaconda
[ -f /opt/anaconda/etc/profile.d/conda.sh ] && source /opt/anaconda/etc/profile.d/conda.sh
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=true

# for ocaml's `opam`
eval $(opam env --switch=default)

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
alias n='!nvim'

# zathura shortcut
alias za='zathura'

# yazi shortcut
alias yz="yazi"

# Suspend & Hibernate Shorthand
alias sus='cd | systemctl suspend'
alias suspend=sus
# alias hib='cd | systemctl hibernate'  # Not in use

# Rank Arch Mirrors
alias arch-mirror-rank="rate-mirrors --disable-comments-in-file --entry-country=CA --protocol=https arch --max-delay 7200 | sudo tee /etc/pacman.d/mirrorlist"

###############################
### Lazy dumb git functions ###
###############################
function acp() {
    git add .
    git commit -a -m "$1"
    git push
}

# Minimal git wrapper: register all clones + remote adds with mr
git() {
  if [[ "$1" == "clone" ]]; then
    command git "$@"
    local dest="${@: -1}"
    dest="${dest%.git}"
    [[ -d "$dest" ]] && mr register "$dest"

  elif [[ "$1" == "remote" && "$2" == "add" ]]; then
    command git "$@"
    mr register "$(pwd)"

  else
    command git "$@"
  fi
}

log_dmesg() {
  local log_dir="$HOME/dmesg_logs"
  mkdir -p "$log_dir"

  local timestamp
  timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

  local log_file="$log_dir/dmesg_$timestamp.log"

  echo "Logging dmesg to: $log_file"
  echo "Press Ctrl+C to stop logging."

  sudo dmesg -wT | tee "$log_file"
}

function codediff() {
    local file1="$1"
    local file2="$2"

    # Simple comment removal for common languages
    case "${file1##*.}" in
        py|pl|rb|sh)
            diff <(grep -v '^[[:space:]]*#' "$file1") <(grep -v '^[[:space:]]*#' "$file2")
            ;;
        c|cpp|java|js)
            diff <(grep -v '^[[:space:]]*//' "$file1" | grep -v '^[[:space:]]*/\*' | grep -v '\*/') \
                 <(grep -v '^[[:space:]]*//' "$file2" | grep -v '^[[:space:]]*/\*' | grep -v '\*/')
            ;;
        *)
            echo "Unsupported file type"
            ;;
    esac
}
