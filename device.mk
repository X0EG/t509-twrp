#
# Copyright (C) 2020 The Android Open Source Project
# Copyright (C) 2020 The TWRP Open Source Project
# Copyright (C) 2020 SebaUbuntu's TWRP device tree generator
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/samsung/gta4lve

# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

PRODUCT_PLATFORM := ums512
PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
    android.hardware.boot@1.0-impl-wrapper.recovery \
    android.hardware.boot@1.0-impl-wrapper \
    android.hardware.boot@1.0-impl.recovery \
    bootctrl.$(PRODUCT_PLATFORM) \
    bootctrl.$(PRODUCT_PLATFORM).recovery \
    libresetprop \
    debuggerd \
    crash_dump \

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

PRODUCT_PACKAGES_ENG += \
    tzdata_twrp

# Override default properties for unsecured ADB in recovery
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.secure=0 \
    ro.adb.secure=0 \
    ro.debuggable=1 \
    persist.service.adb.enable=1 \
    persist.sys.usb.config=adb \
    sys.usb.config=adb

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/vendor/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/manifest.xml \
    $(LOCAL_PATH)/recovery/root/init.recovery.gta4lve.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.gta4lve.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.graphics.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.graphics.rc \
    $(LOCAL_PATH)/recovery/root/sbin/permissive.sh:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/permissive.sh \
    $(LOCAL_PATH)/recovery/root/init.recovery.system_protection.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.system_protection.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.fixes.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.fixes.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.hlthchrg.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.hlthchrg.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.logd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.logd.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.service.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.service.rc \
    $(LOCAL_PATH)/recovery/root/system/bin/android.hardware.health@2.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.health@2.0-service
