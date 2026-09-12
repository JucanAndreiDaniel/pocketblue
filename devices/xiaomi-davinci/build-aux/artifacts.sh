#!/usr/bin/env bash

set -uexo pipefail

which git
which python

# U-Boot images are downloaded as raw .img files via extra-sources
# (samsung panel is the tested default, visionox is shipped as well).
# download-extra.sh places them under $OUT_PATH/images/.
ls -l $OUT_PATH/images/u-boot-davinci-samsung.img
ls -l $OUT_PATH/images/u-boot-davinci-visionox.img

git clone --depth=1 https://android.googlesource.com/platform/external/avb
python avb/avbtool.py make_vbmeta_image --flags 2 --padding_size 4096 --output $OUT_PATH/images/vbmeta-disabled.img

install -Dm 0755 $DEVICE_PATH/flash-scripts/flash.sh $OUT_PATH/flash.sh
install -Dm 0755 $DEVICE_PATH/flash-scripts/flash.cmd $OUT_PATH/flash.cmd
