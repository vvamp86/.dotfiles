#!/bin/bash

print_step() {
  echo -e "${GREEN}==> $1...${NC}"
}

read -p "Set Wallpaper? [y/N]: " wallpaper
if [[ "$wallpaper" == [yY] ]]; then
  # Default directory is current dir or use first argument
  WP="$HOME/.dotfiles/wallpapers"

  # Get sorted list of files only (ignore dirs)
  mapfile -t files < <(find "$WP" -maxdepth 1 -type f | sort)

  # Check if files were found
  if [[ ${#files[@]} -eq 0 ]]; then
    print_step "No files found in $WP"
    exit 1
  fi

  # Display files with numbers
  echo "Files in $WP:"
  for i in "${!files[@]}"; do
    printf "[%2d] %s\n" "$((i + 1))" "${files[i]##*/}"
  done

  # Prompt user for selection
  read -p "Enter file number: " num

  # Validate input
  if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#files[@]} )); then
    print_step "Invalid selection."
    exit 1
  fi

  # Output the selected file
  WALL="${files[$((num - 1))]}"
  print_step "You selected: $WALL"

  sudo rm -rf /usr/share/backgrounds/
  sudo mkdir -p /usr/share/backgrounds/
  sudo cp $WALL /usr/share/backgrounds/wallpaper.png

  # Blurred Background Image Creation
  print_step "Creating Blurred Background Image"
  PICTURE="/usr/share/backgrounds/wallpaper.png"
  OUTPUT="/usr/share/backgrounds/wallpaper-blur.png"
  BLUR="5x4"

  sudo magick "$PICTURE" -blur "$BLUR" \( -size $(identify -format "%wx%h" "$PICTURE") xc:'rgba(0,0,0,0.5)' \) \
  -compose over -composite "$OUTPUT"
fi

