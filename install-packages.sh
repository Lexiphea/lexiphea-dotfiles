#!/bin/bash

# Package installation script for Arch Linux
# This script installs packages from pacman and AUR (via yay)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Pacman packages
PACMAN_PACKAGES=(
    hyprland
    hyprpaper
    hyprshot
    timeshift
    btop
    thunar
    thunar-actions-plugin
    unzip
    bitwarden
    easyeffects
    spotify-launcher

)

# AUR packages (installed via yay)
AUR_PACKAGES=(
    caelestia-shell
    cursor-bin
    bitwarden-bin
    spicetify-cli
    protontricks
    vesktop-bin
    visual-studio-code-bin
    wtype-git
    zen-browser-bin
    bibata-cursor-theme-bin
)

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

# Update pacman database
print_info "Updating pacman database..."
sudo pacman -Sy

# Install pacman packages
if [ ${#PACMAN_PACKAGES[@]} -gt 0 ]; then
    print_info "Installing pacman packages: ${PACMAN_PACKAGES[*]}"
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
else
    print_warn "No pacman packages to install"
fi

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    print_warn "yay is not installed. Installing yay first..."
    
    # Install yay dependencies
    sudo pacman -S --needed --noconfirm base-devel git
    
    # Clone and install yay
    YAY_DIR="/tmp/yay"
    if [ -d "$YAY_DIR" ]; then
        rm -rf "$YAY_DIR"
    fi
    
    git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
    cd "$YAY_DIR"
    makepkg -si --noconfirm
    cd -
    rm -rf "$YAY_DIR"
    
    print_info "yay installed successfully"
fi

# Install AUR packages
if [ ${#AUR_PACKAGES[@]} -gt 0 ]; then
    print_info "Installing AUR packages: ${AUR_PACKAGES[*]}"
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
else
    print_warn "No AUR packages to install"
fi

print_info "Package installation completed!"

