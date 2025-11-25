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

echo "Please make sure Zen Browser is installed manually (https://zenbrowser.com/downloads)."

mkdir -p "$PROFILE_DIR/chrome"
ln -sf "$ZEN_DIR/userChrome.css" "$PROFILE_DIR/chrome/userChrome.css"
echo "Linked userChrome.css into $PROFILE_DIR/chrome/"

DEST_MANIFEST="$HOME/.mozilla/native-messaging-hosts/caelestiafox.json"
DEST_LIB="$HOME/.local/lib/caelestia"
mkdir -p "$(dirname "$DEST_MANIFEST")" "$DEST_LIB"

sed "s|{{ \$lib }}|$DEST_LIB|" "$ZEN_DIR/native_app/manifest.json" > "$DEST_MANIFEST"
chmod 644 "$DEST_MANIFEST"
echo "Copied native messaging manifest to $DEST_MANIFEST"

ln -sf "$ZEN_DIR/native_app/app.fish" "$DEST_LIB/caelestiafox"
chmod +x "$DEST_LIB/caelestiafox"
echo "Installed native app entry at $DEST_LIB/caelestiafox"

