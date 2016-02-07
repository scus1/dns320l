#!/bin/sh

if [ -e /etc/default/fancontrol ]; then
    . /etc/default/fancontrol
else
    >&2 echo "No config found, taking default values"

    LOW_THRESHOLD=30
    HIGH_THRESHOLD=50
    HYSTERESIS=3

    DEBUG=true
fi
    

CUR_FAN_SPEED=FAN_INIT

while true; do
    MAX_TEMP=$(mcu_communicate THERMAL_STATUS)
    if [ "$?" -ne 0 ]; then
        MAX_TEMP=99
        >&2 echo "Could not determine CPU temperature, assuming worst case"
    else
        $DEBUG && echo "CPU temperature is ${MAX_TEMP}"
    fi

    for HDD in 1 2; do
        DEV=$(find /sys/devices/platform/ocp@f1000000/f1080000.sata/ata${HDD}/ -regex ".*/sd[a-z]$" -printf %f)
        HDD_TEMP=$(hddtemp -n /dev/${DEV})
        
        if [ "$?" -ne 0 ]; then
            MAX_TEMP=99
            >&2 echo "Could not determine HDD ${HDD} temperature, assuming worst case"
        else
            $DEBUG && echo "HDD ${HDD} temperature is ${HDD_TEMP}"
            if [ "$HDD_TEMP" -gt "$MAX_TEMP" ]; then
                MAX_TEMP=$HDD_TEMP
            fi
        fi
    done

    case "$CUR_FAN_SPEED" in
        FAN_STOP)
            [ "$MAX_TEMP" -gt "$((LOW_THRESHOLD +HYSTERESIS))" ] && NEW_FAN_SPEED=FAN_HALF
            [ "$MAX_TEMP" -gt "$((HIGH_THRESHOLD+HYSTERESIS))" ] && NEW_FAN_SPEED=FAN_FULL
            ;;

        FAN_HALF)
            [ "$MAX_TEMP" -lt "$((LOW_THRESHOLD -HYSTERESIS))" ] && NEW_FAN_SPEED=FAN_STOP
            [ "$MAX_TEMP" -gt "$((HIGH_THRESHOLD+HYSTERESIS))" ] && NEW_FAN_SPEED=FAN_FULL
            ;;

        FAN_FULL)
            [ "$MAX_TEMP" -lt "$((HIGH_THRESHOLD-HYSTERESIS))" ] && NEW_FAN_SPEED=FAN_HALF
            [ "$MAX_TEMP" -lt "$((LOW_THRESHOLD -HYSTERESIS))" ] && NEW_FAN_SPEED=FAN_STOP
            ;;
        FAN_INIT)
            NEW_FAN_SPEED=FAN_FULL
            [ "$MAX_TEMP" -lt "$((HIGH_THRESHOLD))" ] && NEW_FAN_SPEED=FAN_HALF
            [ "$MAX_TEMP" -lt "$((LOW_THRESHOLD))" ] && NEW_FAN_SPEED=FAN_STOP
            ;;
            
    esac

    if [ "$NEW_FAN_SPEED" != "$CUR_FAN_SPEED" ]; then
        CUR_FAN_SPEED=$NEW_FAN_SPEED
        echo "Adjusting fan speed, new fan speed is ${NEW_FAN_SPEED}"

        mcu_communicate $CUR_FAN_SPEED || exit 1
    fi
    sleep 15s
done