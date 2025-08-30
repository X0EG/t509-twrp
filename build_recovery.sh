#!/bin/bash

DEVICE_PATH="/workspace"
OUT_DIR="$DEVICE_PATH/out"
RECOVERY_IMG="$OUT_DIR/recovery.img"
RECOVERY_SIZE=67108864

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

if [ ! -f "$DEVICE_PATH/prebuilt/dtbo.img" ]; then
    echo "Error: DTBO image not found!"
    exit 1
fi

echo "Creating recovery ramdisk..."
cd $DEVICE_PATH/recovery/root

mkdir -p sbin system/bin system/lib system/lib64 system/etc system/recovery-resource-res/images
mkdir -p vendor/lib vendor/lib64 vendor/bin vendor/etc

chmod 755 sbin/recovery sbin/twrp 2>/dev/null || true
chmod 755 system/bin/recovery system/bin/twrp 2>/dev/null || true

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
    --cmdline "console=ttyS1,115200n8" \
    --header_version 2 \
    -o $RECOVERY_IMG

if [ -f "$RECOVERY_IMG" ]; then
    CURRENT_SIZE=$(stat -c%s "$RECOVERY_IMG")
    echo "Current recovery size: $CURRENT_SIZE bytes"
    echo "Required recovery size: $RECOVERY_SIZE bytes"
    
    if [ $CURRENT_SIZE -lt $RECOVERY_SIZE ]; then
        echo "Padding recovery image to match partition size..."
        dd if=/dev/zero bs=1 count=$((RECOVERY_SIZE - CURRENT_SIZE)) >> $RECOVERY_IMG 2>/dev/null
    fi
    
    echo "Recovery image built successfully: $RECOVERY_IMG"
    ls -lh $RECOVERY_IMG
    echo "Recovery size: $(stat -c%s "$RECOVERY_IMG") bytes ($(echo "scale=1; $(stat -c%s "$RECOVERY_IMG")/1024/1024" | bc)MB)"
else
    echo "Failed to build recovery image!"
    exit 1
fi