#!/bin/bash

# Default directory is current dir or use first argument
DIR="$HOME/.dotfiles/wallpapers"

# Get sorted list of files only (ignore dirs)
mapfile -t files < <(find "$DIR" -maxdepth 1 -type f | sort)

# Check if files were found
if [[ ${#files[@]} -eq 0 ]]; then
  echo "No files found in $DIR"
  exit 1
fi

# Display files with numbers
echo "Files in $DIR:"
for i in "${!files[@]}"; do
  printf "[%2d] %s\n" "$((i + 1))" "${files[i]##*/}"
done

# Prompt user for selection
read -p "Enter file number: " num

# Validate input
if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#files[@]} )); then
  echo "Invalid selection."
  exit 1
fi

# Output the selected file
selected="${files[$((num - 1))]}"
echo "You selected: $selected"
