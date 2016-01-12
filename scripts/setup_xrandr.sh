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
    exit
fi

if [ $DP2 ] && [ $DP3 ]; then
    xrandr_VHh.sh
fi

if [ $VGA ]; then
    xrandr_vga_extern.sh
fi
