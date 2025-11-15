#!/bin/bash

# Clone or pull the repo
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone <your-repo-url> "$DOTFILES_DIR"
else
    cd "$DOTFILES_DIR" && git pull
fi

# Install Stow if missing
if ! command -v stow &> /dev/null; then
    sudo pacman -Syu --noconfirm stow
fi

# Remove existing configs to avoid conflicts (backup first if needed)
rm -rf "$HOME/.config/hypr" "$HOME/.config/kitty"  # Add more as needed

# Symlink via Stow
cd "$DOTFILES_DIR"
stow hypr kitty  # Add other packages like waybar, etc.

echo "Dotfiles restored. Reload Hyprland with: hyprctl reload"