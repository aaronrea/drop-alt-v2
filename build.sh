#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QMK_DIR="$SCRIPT_DIR/qmk_firmware"
KEYMAP="${1:-area}"

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
