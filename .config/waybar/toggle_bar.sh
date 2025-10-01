#!/usr/bin/env sh

waybar_pid=$(pidof waybar)

if [ $waybar_pid > 0 ] ; then
    kill -10 $waybar_pid
else
    waybar
fi
