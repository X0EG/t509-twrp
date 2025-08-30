#!/sbin/sh
if [ "$(getprop ro.bootmode)" = "recovery" ]; then
    setenforce 0
    mount -o remount,ro /system 2>/dev/null
    mount -o remount,ro /vendor 2>/dev/null
    mount -o remount,ro /product 2>/dev/null
    setprop ro.recovery.temp_mode 1
fi