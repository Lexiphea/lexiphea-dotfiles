#!/bin/bash
# Apply caelestia-cli Qt theming patches
# Run with: sudo bash apply-patches.sh

set -euo pipefail

PATCH_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

if [[ -z "${CAELESTIA_DIR:-}" ]]; then
    PYTHON_BIN="${PYTHON_BIN:-$(command -v python3 || command -v python)}"
    CAELESTIA_DIR="$(${PYTHON_BIN} -c 'import pathlib, caelestia; print(pathlib.Path(caelestia.__file__).resolve().parent)')"
fi

backup_file() {
    local path="$1"
    local backup="${path}.bak"

    if [[ -e "${path}" && ! -e "${backup}" ]]; then
        cp -v "${path}" "${backup}"
    fi
}

echo "=== Backing up original files ==="
backup_file "${CAELESTIA_DIR}/utils/colour.py"
backup_file "${CAELESTIA_DIR}/utils/theme.py"
backup_file "${CAELESTIA_DIR}/data/templates/qtct.conf"
backup_file "${CAELESTIA_DIR}/data/templates/qtdark.conf"
backup_file "${CAELESTIA_DIR}/data/templates/qtlight.conf"

echo ""
echo "=== Applying patches ==="
cp -v "${PATCH_DIR}/colour.py" "${CAELESTIA_DIR}/utils/colour.py"
cp -v "${PATCH_DIR}/theme.py" "${CAELESTIA_DIR}/utils/theme.py"
cp -v "${PATCH_DIR}/qtct.conf" "${CAELESTIA_DIR}/data/templates/qtct.conf"
cp -v "${PATCH_DIR}/qtdark.conf" "${CAELESTIA_DIR}/data/templates/qtdark.conf"
cp -v "${PATCH_DIR}/qtlight.conf" "${CAELESTIA_DIR}/data/templates/qtlight.conf"

echo ""
echo "=== Patches applied successfully! ==="
echo "Patched package: ${CAELESTIA_DIR}"
echo "Run 'caelestia scheme set -m dark' to test."
