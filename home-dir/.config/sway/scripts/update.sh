#!/bin/bash

# Log file location
LOG_FILE="$HOME/.update-logs/update_log-$(date +%Y-%m-%d_%H:%M:%S).log"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Log start
echo "Update script started at $(date)" >> "$LOG_FILE"

# Update pacman & AUR packages
echo "Running yay..." >> "$LOG_FILE"
yay -Syu --noconfirm 2>&1 >> "$LOG_FILE"

# Update firmware
echo "Updating firmware..." >> "$LOG_FILE"
fwupdmgr refresh --force 2>&1 >> "$LOG_FILE"
fwupdmgr get-updates 2>&1 >> "$LOG_FILE"
fwupdmgr update 2>&1 >> "$LOG_FILE"

echo "Update script completed at $(date)" >> "$LOG_FILE"

### Future Upgrade for more interaction
# exec </dev/tty   # hard-bind dialog to the terminal
#
# LOG_DIR="$HOME/.update-logs"
# LOG_FILE="$LOG_DIR/update-$(date +%F_%H-%M-%S).log"
# mkdir -p "$LOG_DIR"
#
# RAN_UPDATE=0
# REBOOT_CHOICE=1
#
# run_task() {
#   RAN_UPDATE=1
#   (
#     echo 20
#     yay -Syu --noconfirm >>"$LOG_FILE" 2>&1
#     echo 70
#     fwupdmgr refresh --force >>"$LOG_FILE" 2>&1
#     fwupdmgr get-updates >>"$LOG_FILE" 2>&1
#     fwupdmgr update >>"$LOG_FILE" 2>&1
#     echo 100
#   ) | dialog --gauge "Running updates…" 8 60 0
# }
#
# while true; do
#   CHOICE=$(dialog --menu "System Update Utility" 15 60 4 \
#     1 "Run updates" \
#     2 "Exit" \
#     2>&1 >/dev/tty)
#
#   STATUS=$?
#
#   if [[ $STATUS -ne 0 ]]; then
#     break   # ESC / Cancel
#   fi
#
#   case "$CHOICE" in
#     1)
#       run_task
#       break
#       ;;
#     2)
#       break
#       ;;
#   esac
# done
#
# if [[ $RAN_UPDATE -eq 1 ]]; then
#   dialog --yesno "Updates completed.\n\nReboot now?" 8 50
#   REBOOT_CHOICE=$?
# fi
#
# clear
#
# if [[ $REBOOT_CHOICE -eq 0 ]]; then
#   reboot
# else
#   echo "Done. Log: $LOG_FILE"
#   echo
#   echo "Press Enter to close."
#   read
# fi
