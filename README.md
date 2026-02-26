# drop-alt-v2

QMK keymap for the [Drop ALT V2](https://drop.com/buy/drop-alt-mechanical-keyboard).

## Keymap changes from stock

| Key | Stock | This |
|-----|-------|------|
| Caps Lock | Caps Lock | `` ` `` / `~` |
| Bottom-left modifiers | Ctrl, Win, Alt | Ctrl, Alt, Cmd |
| RGB default | Stock animation | Solid blue |

Fn layer is otherwise unchanged (Fn+B = QK_BOOT, Fn+RGB keys, etc).

## Build

Requires Docker.

```bash
./build.sh
```

Outputs `qmk_firmware/drop_alt_v2_area.uf2`.

## Flash

1. Enter bootloader: hold **Esc** while plugging in USB (or **Fn+B** from within QMK)
2. A USB drive mounts — copy the `.uf2` to it
3. Keyboard reboots automatically

## Structure

```
keymaps/area/keymap.c   ← edit this
build.sh                ← compiles via Docker (qmkfm/qmk_cli)
qmk_firmware/           ← gitignored, auto-cloned at pinned commit
```
