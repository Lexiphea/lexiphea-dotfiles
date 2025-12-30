# Caelestia-CLI Qt Theming Patches

This directory contains patches to fix Qt5/Qt6 theming in caelestia-cli.

## Problem

Caelestia generates Qt color schemes in KDE Plasma format (`[Colors:Button]`, etc.), but qt5ct/qt6ct expects a different format (`[ColorScheme]` with comma-separated ARGB values).

## Changes Made

| File | Change |
|------|--------|
| `colour.py` | Added `argb` property for `#ffRRGGBB` format |
| `theme.py` | Fixed `apply_qt()` to use `gen_replace_dynamic` and `.conf` extension; Fixed `apply_gtk()` to use correct theme based on mode |
| `qtct.conf` | Changed color scheme path to `.conf` extension |
| `qtdark.conf` | **NEW** - Dark mode qt5ct color scheme template |
| `qtlight.conf` | **NEW** - Light mode qt5ct color scheme template |

## Applying Patches

```bash
sudo bash ~/.dotfiles/adhoc/caelestia-patches/apply-patches.sh
```

## Reverting Patches

```bash
sudo bash ~/.dotfiles/adhoc/caelestia-patches/revert-patches.sh
```

## Note

These patches will be overwritten when caelestia-cli is updated. Re-apply after updates.
