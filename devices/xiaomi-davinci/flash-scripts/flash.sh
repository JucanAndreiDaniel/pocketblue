#!/usr/bin/env bash

set -ueo pipefail

which fastboot

# Panel variant: samsung (tested default) or visionox.
# Usage: PANEL=visionox ./flash.sh
PANEL="${PANEL:-samsung}"

case "$PANEL" in
    samsung) UBOT_IMG="images/u-boot-davinci-samsung.img" ;;
    visionox) UBOT_IMG="images/u-boot-davinci-visionox.img" ;;
    *) echo "Unknown panel '$PANEL' (use samsung or visionox)"; exit 1 ;;
esac

echo ">>> Flashing xiaomi-davinci (panel: $PANEL)"

echo '>>> Waiting for device to appear in fastboot...'
fastboot getvar product 2>&1 | grep -i davinci

echo '>>> (1/6) Erasing DTBO'
fastboot erase dtbo

echo '>>> (2/6) Disabling verified boot'
fastboot flash vbmeta images/vbmeta-disabled.img

echo ">>> (3/6) Flashing U-Boot ($UBOT_IMG)"
fastboot flash boot "$UBOT_IMG"

echo ">>> (4/6) Flashing fedora_esp.raw into cache"
fastboot flash cache images/fedora_esp.raw

echo ">>> (5/6) Flashing fedora_rootfs.raw into userdata"
fastboot flash userdata images/fedora_rootfs.raw

echo '>>> (6/6) Writing to disk and rebooting (this may take a while, DO NOT DISCONNECT THE DEVICE)'
fastboot reboot
