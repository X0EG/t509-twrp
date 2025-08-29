#!/bin/bash

DEVICE_PATH="/workspace"
OUT_DIR="$DEVICE_PATH/out"
RECOVERY_IMG="$OUT_DIR/recovery.img"

echo "Building TWRP Recovery for Samsung Galaxy Tab A7 Lite (gta4lve)..."

mkdir -p $OUT_DIR

if [ ! -f "$DEVICE_PATH/prebuilt/kernel" ]; then
    echo "Error: Prebuilt kernel not found!"
    exit 1
fi

if [ ! -f "$DEVICE_PATH/prebuilt/dtb.img" ]; then
    echo "Error: DTB image not found!"
    exit 1
fi

echo "Creating recovery ramdisk..."
cd $DEVICE_PATH/recovery/root
find . | cpio -o -H newc | gzip > $OUT_DIR/ramdisk-recovery.cpio.gz

echo "Building recovery image..."
cd $DEVICE_PATH

mkbootimg \
    --kernel prebuilt/kernel \
    --ramdisk $OUT_DIR/ramdisk-recovery.cpio.gz \
    --dtb prebuilt/dtb.img \
    --base 0x00000000 \
    --kernel_offset 0x00008000 \
    --ramdisk_offset 0x01000000 \
    --tags_offset 0x00000100 \
    --pagesize 2048 \
    --cmdline "console=ttyS1,115200n8 androidboot.selinux=permissive buildvariant=eng" \
    --header_version 2 \
    -o $RECOVERY_IMG

if [ -f "$RECOVERY_IMG" ]; then
    echo "Recovery image built successfully: $RECOVERY_IMG"
    ls -lh $RECOVERY_IMG
else
    echo "Failed to build recovery image!"
    exit 1
fi