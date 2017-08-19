# ! /usr/bin/env bash

function monitor_connected {
    MONITOR=$1
    xrandr | grep "$MONITOR connected" > /dev/null
    echo $?
}

VGA=$(monitor_connected "VGA-1")
DP2=$(monitor_connected "DP-2")
DP3=$(monitor_connected "DP-3")

if [ "$1" == "test" ]; then
    echo "VGA: $VGA"
    echo "DP-2: $DP2"
    echo "DP-3: $DP3"
fi

if [ "$DP2" == "0" ] && [ "$DP3" == "0" ]; then
    if [ "$1" == "test" ]; then echo "Home"; fi
    xrandr_VHh.sh
elif [ "$VGA" == "0" ]; then
    if [ "$1" == "test" ]; then echo "Uni"; fi
    xrandr_vga_uni.sh
else
    if [ "$1" == "test" ]; then echo "Clear"; fi
    xrandr_clear.sh
fi


