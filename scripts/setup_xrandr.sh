#! /usr/bin/env bash

function monitor_connected {
    MONITOR=$1
    xrandr | grep "$MONITOR connected" > /dev/null
    echo $?
}

VGA=$(monitor_connected "VGA1")
DP2=$(monitor_connected "DP2")
DP3=$(monitor_connected "DP3")

if [ "$1" == "test" ]; then
    echo "VGA: $VGA"
    echo "DP2: $DP2"
    echo "DP3: $DP3"
fi

if [ "$DP2" == "0" ] && [ "$DP3" == "0" ]; then
    if [ "$1" == "test"]; then echo "Home"; fi
    xrandr_VHh.sh
elif [ "$VGA" == "0" ]; then
    if [ "$1" == "test" ]; then echo "Uni"; fi
    xrandr_vga_uni.sh
else
    if [ "$1" == "test" ]; then echo "Clear"; fi
    xrandr_clear.sh
fi


