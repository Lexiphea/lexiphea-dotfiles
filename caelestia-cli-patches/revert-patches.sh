#!/bin/bash
# Revert caelestia-cli Qt theming patches
# Run with: sudo bash revert-patches.sh

set -euo pipefail

if [[ -z "${CAELESTIA_DIR:-}" ]]; then
    PYTHON_BIN="${PYTHON_BIN:-$(command -v python3 || command -v python)}"
    CAELESTIA_DIR="$(${PYTHON_BIN} -c 'import pathlib, caelestia; print(pathlib.Path(caelestia.__file__).resolve().parent)')"
fi

restore_file() {
    local path="$1"
    local backup="${path}.bak"

    if [[ -e "${backup}" ]]; then
        cp -v "${backup}" "${path}"
    else
        echo "Skipping ${path}; no backup found"
    fi
}

restore_or_remove() {
    local path="$1"
    local backup="${path}.bak"

    if [[ -e "${backup}" ]]; then
        cp -v "${backup}" "${path}"
    else
        rm -f "${path}"
    fi
}

echo "=== Reverting to original files ==="
restore_file "${CAELESTIA_DIR}/utils/colour.py"
restore_file "${CAELESTIA_DIR}/utils/theme.py"
restore_or_remove "${CAELESTIA_DIR}/data/templates/qtct.conf"
restore_or_remove "${CAELESTIA_DIR}/data/templates/qtdark.conf"
restore_or_remove "${CAELESTIA_DIR}/data/templates/qtlight.conf"

echo ""
echo "=== Patches reverted successfully! ==="
echo "Patched package: ${CAELESTIA_DIR}"
