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
