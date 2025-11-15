#!/bin/bash

# Script to automate ZIP extraction setup for Thunar on EndeavourOS/Hyprland
# Usage: Save as setup-zip-extract.sh in .dotfiles, then chmod +x and run

set -e  # Exit on error

USER_HOME="$HOME"
BIN_DIR="$USER_HOME/bin"
SCRIPT_PATH="$BIN_DIR/extract-zip.sh"
DESKTOP_PATH="$USER_HOME/.local/share/applications/extract-zip.desktop"

echo "Setting up ZIP extraction handler..."

# Check if unzip is installed
if ! pacman -Q unzip &> /dev/null; then
    echo "unzip not found. Installing via pacman..."
    sudo pacman -S unzip --noconfirm
else
    echo "unzip is already installed."
fi

# Create bin dir if needed
mkdir -p "$BIN_DIR"

# Create or update the extraction script
cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash
file="$1"
dir="${file%.*}"
unzip -q "$file" -d "$dir"
EOF

# Make executable
chmod +x "$SCRIPT_PATH"

# Create or update the .desktop file
cat > "$DESKTOP_PATH" << EOF
[Desktop Entry]
Name=Extract ZIP to Folder
Comment=Extract ZIP archive to a new folder
Exec=$SCRIPT_PATH %F
Type=Application
Terminal=false
MimeType=application/zip;
NoDisplay=false
Categories=Utility;Archiving;
Icon=archive-extract
EOF

# Update desktop database
update-desktop-database "$USER_HOME/.local/share/applications"

# Set MIME default
xdg-mime default extract-zip.desktop application/zip

# Restart Thunar to apply changes
pkill thunar 2>/dev/null || true

echo "Setup complete. Double-click .zip files in Thunar to extract to a new folder."
echo "To revert: xdg-mime default org.gnome.FileRoller.desktop application/zip && update-desktop-database ~/.local/share/applications && pkill thunar"