#!/bin/sh

while true; do
    for HDD in 1 2; do
        DEV=$(find /sys/devices/platform/ocp@f1000000/f1080000.sata/ata${HDD}/ -regex ".*/sd[a-z]$" -printf %f)
        REALLOC=$(smartctl -A /dev/${DEV} | grep Reallocated_Sector_Ct | awk '{print $10}')

        if [ "$REALLOC" != "0" ]; then
            >&2 echo "Harddisk ${HDD} is about to fail!"
            echo default-on > /sys/class/leds/hdd${HDD}_orange/trigger
        else
            echo "No reallocated sectors for HDD ${HDD}" 
            echo none > /sys/class/leds/hdd${HDD}_orange/trigger
        fi
    done

    sleep 15m
done
