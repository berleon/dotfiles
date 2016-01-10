#! /usr/bin/env bash
xrandr | grep "DP2 connected" > /dev/null
DP2=$?
xrandr | grep "DP3 connected" > /dev/null
DP3=$?

if [ $DP2 ] && [ $DP3 ]; then
    xrandr_VHh.sh
fi
