#!/bin/bash
# Apply caelestia-cli Qt theming patches
# Run with: sudo bash apply-patches.sh

set -e

PATCH_DIR="$(dirname "$0")"
CAELESTIA_DIR="/usr/lib/python3.13/site-packages/caelestia"

echo "=== Backing up original files ==="
cp -v "${CAELESTIA_DIR}/utils/colour.py" "${CAELESTIA_DIR}/utils/colour.py.bak"
cp -v "${CAELESTIA_DIR}/utils/theme.py" "${CAELESTIA_DIR}/utils/theme.py.bak"
cp -v "${CAELESTIA_DIR}/data/templates/qtct.conf" "${CAELESTIA_DIR}/data/templates/qtct.conf.bak"

echo ""
echo "=== Applying patches ==="
cp -v "${PATCH_DIR}/colour.py" "${CAELESTIA_DIR}/utils/colour.py"
cp -v "${PATCH_DIR}/theme.py" "${CAELESTIA_DIR}/utils/theme.py"
cp -v "${PATCH_DIR}/qtct.conf" "${CAELESTIA_DIR}/data/templates/qtct.conf"
cp -v "${PATCH_DIR}/qtdark.conf" "${CAELESTIA_DIR}/data/templates/qtdark.conf"
cp -v "${PATCH_DIR}/qtlight.conf" "${CAELESTIA_DIR}/data/templates/qtlight.conf"

echo ""
echo "=== Patches applied successfully! ==="
echo "Run 'caelestia scheme set -m dark' to test."
