#!/bin/bash
# Revert caelestia-cli Qt theming patches
# Run with: sudo bash revert-patches.sh

set -e

CAELESTIA_DIR="/usr/lib/python3.13/site-packages/caelestia"

echo "=== Reverting to original files ==="
cp -v "${CAELESTIA_DIR}/utils/colour.py.bak" "${CAELESTIA_DIR}/utils/colour.py"
cp -v "${CAELESTIA_DIR}/utils/theme.py.bak" "${CAELESTIA_DIR}/utils/theme.py"
cp -v "${CAELESTIA_DIR}/data/templates/qtct.conf.bak" "${CAELESTIA_DIR}/data/templates/qtct.conf"

# Remove new template files
rm -f "${CAELESTIA_DIR}/data/templates/qtdark.conf"
rm -f "${CAELESTIA_DIR}/data/templates/qtlight.conf"

echo ""
echo "=== Patches reverted successfully! ==="
