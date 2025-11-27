#!/bin/bash

set -e

echo "Configuring GameMode (assumes gamemode package is installed)..."

# Add user to gamemode group if not already
if ! groups | grep -q gamemode; then
    echo "Adding user to gamemode group..."
    sudo usermod -aG gamemode "$USER"
    echo "User added to gamemode group. Please log out and log back in for the group change to take effect."
else
    echo "User is already in gamemode group."
fi

# Create config directory and basic config
CONFIG_DIR="$HOME/.config/gamemode"
mkdir -p "$CONFIG_DIR"
cat > "$CONFIG_DIR/gamemode.ini" << 'EOF'
[general]
renice=0
sched_nice=-10
cgroup=/game_mode
cpuprio=3
iostartupprio=0

[system]
enable_polling=false
EOF

echo "GameMode user group and config setup complete!"
echo "Remember to log out/in if added to group."
echo "Usage: gamemoderun your_game"
echo "For Steam: gamemoderun %command%"