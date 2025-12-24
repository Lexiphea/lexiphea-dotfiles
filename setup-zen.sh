#!/usr/bin/env bash
set -euo pipefail

ZEN_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/zen"

function usage() {
    cat <<'EOF'
Usage: setup-zen.sh <profile-name>

This script helps wiring your Zen Browser profile to the Caelestia resources.
Steps performed:
 1. Reminds you to install Zen Browser manually.
 2. Symlinks zen/userChrome.css into ~/.zen/<profile>/chrome/.
 3. Installs the native messaging host by writing the manifest with the Caelestia
     library path and linking the helper script.

Arguments:
  profile-name   Name of the Zen profile (the subdirectory under ~/.zen/).
EOF
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

PROFILE="$1"
PROFILE_DIR="$HOME/.zen/$PROFILE"

if [ ! -d "$PROFILE_DIR" ]; then
    echo "Zen profile '$PROFILE' not found under ~/.zen/" >&2
    exit 1
fi

# Validate required files exist
if [ ! -f "$ZEN_DIR/userChrome.css" ]; then
    echo "Error: $ZEN_DIR/userChrome.css not found" >&2
    exit 1
fi

if [ ! -f "$ZEN_DIR/native_app/manifest.json" ]; then
    echo "Error: $ZEN_DIR/native_app/manifest.json not found" >&2
    exit 1
fi

if [ ! -f "$ZEN_DIR/native_app/app.fish" ]; then
    echo "Error: $ZEN_DIR/native_app/app.fish not found" >&2
    exit 1
fi

# Check for required dependencies
for cmd in fish jq inotifywait; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' not found. Please install it first." >&2
        exit 1
    fi
done

echo "Please make sure Zen Browser is installed manually (yay -S zen-browser-bin)."

mkdir -p "$PROFILE_DIR/chrome"
ln -sf "$ZEN_DIR/userChrome.css" "$PROFILE_DIR/chrome/userChrome.css"
echo "Linked userChrome.css into $PROFILE_DIR/chrome/"

DEST_MANIFEST="$HOME/.mozilla/native-messaging-hosts/caelestiafox.json"
DEST_LIB="$HOME/.local/lib/caelestia"
mkdir -p "$(dirname "$DEST_MANIFEST")" "$DEST_LIB"

sed "s|{{ \$lib }}|$DEST_LIB|" "$ZEN_DIR/native_app/manifest.json" > "$DEST_MANIFEST"
chmod 644 "$DEST_MANIFEST"
echo "Copied native messaging manifest to $DEST_MANIFEST"

# Create a wrapper script that invokes fish explicitly
cat > "$DEST_LIB/caelestiafox" << 'WRAPPER'
#!/bin/bash
exec fish "$(dirname "$(realpath "$0")")/app.fish" "$@"
WRAPPER
chmod +x "$DEST_LIB/caelestiafox"

# Symlink the actual fish script alongside the wrapper
ln -sf "$ZEN_DIR/native_app/app.fish" "$DEST_LIB/app.fish"
echo "Installed native app entry at $DEST_LIB/caelestiafox"

