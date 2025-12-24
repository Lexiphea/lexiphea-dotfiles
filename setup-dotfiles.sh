#!/bin/bash

# Dotfiles setup script
# This script sets up the dotfiles repository and installs required packages

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

DOTFILES_DIR="$HOME/.dotfiles"

# Clone or pull the repo
print_info "Setting up dotfiles repository..."
if [ ! -d "$DOTFILES_DIR" ]; then
    print_info "Cloning dotfiles repository..."
    git clone https://github.com/Lexiphea/lexiphea-dotfiles "$DOTFILES_DIR"
else
    print_info "Updating dotfiles repository..."
    cd "$DOTFILES_DIR" && git pull
fi

# Install required packages
if [ -f "$DOTFILES_DIR/install-packages.sh" ]; then
    print_info "Installing required packages..."
    bash "$DOTFILES_DIR/install-packages.sh"
else
    print_warn "install-packages.sh not found, skipping package installation"
fi

# Install Stow if missing
if ! command -v stow &> /dev/null; then
    print_info "Installing stow..."
    sudo pacman -Syu --noconfirm stow
fi

# Remove existing configs to avoid conflicts (backup first if needed)
print_info "Cleaning up existing configs..."
rm -rf "$HOME/.config/hypr" "$HOME/.config/kitty"  # Add more as needed

# Symlink via Stow
print_info "Creating symlinks via Stow..."
cd "$DOTFILES_DIR"
stow hypr kitty  # Add other packages like waybar, etc.

print_info "Dotfiles setup completed!"
print_info "Reload Hyprland with: hyprctl reload"