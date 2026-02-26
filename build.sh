#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QMK_DIR="$SCRIPT_DIR/qmk_firmware"
KEYMAP="${1:-area}"
QMK_PINNED="9e8199c41189a2eb6243600bf3f96f136650820b"

# Check qmk_firmware exists and is at the pinned commit
if [ ! -d "$QMK_DIR/.git" ]; then
    echo "qmk_firmware not found. Cloning..."
    git clone --depth 1 --recurse-submodules --shallow-submodules \
        https://github.com/qmk/qmk_firmware.git "$QMK_DIR"
    git -C "$QMK_DIR" fetch --depth 1 origin "$QMK_PINNED"
    git -C "$QMK_DIR" checkout "$QMK_PINNED"
else
    ACTUAL=$(git -C "$QMK_DIR" rev-parse HEAD)
    if [ "$ACTUAL" != "$QMK_PINNED" ]; then
        echo "WARNING: qmk_firmware is at $ACTUAL"
        echo "         expected            $QMK_PINNED"
        echo "Run with --update to re-clone at the pinned commit, or proceed anyway? [y/N]"
        read -r reply
        [ "$reply" = "y" ] || [ "$reply" = "Y" ] || exit 1
    fi
fi

echo "Building drop/alt/v2:$KEYMAP ..."

# Sync keymap from repo into qmk_firmware before building
if [ -d "$SCRIPT_DIR/keymaps/$KEYMAP" ]; then
    mkdir -p "$QMK_DIR/keyboards/drop/alt/keymaps/$KEYMAP"
    cp "$SCRIPT_DIR/keymaps/$KEYMAP/"* "$QMK_DIR/keyboards/drop/alt/keymaps/$KEYMAP/"
fi

docker run --rm \
  -v "$QMK_DIR":/qmk_firmware \
  qmkfm/qmk_cli \
  qmk compile -kb drop/alt/v2 -km "$KEYMAP"

echo ""
echo "Done! Firmware file:"
ls -lh "$QMK_DIR"/drop_alt_v2_*.uf2 2>/dev/null || \
ls -lh "$QMK_DIR"/drop_alt_v2_*.bin 2>/dev/null || \
echo "(check qmk_firmware/ for output file)"
