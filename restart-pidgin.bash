#!/usr/bin/env bash

# 20180626
# slack plugin drops connection overnight
# currently: use pythong to disable and re-enable
# previously: restart pidgin to reconnect

# pidgin should already be running
pgrep pidgin || exit 1
# get display
[ -z "$DISPLAY" ] &&
  export $(perl -lne 'print $& if m/DISPLAY=.*?:\d+/' /proc/$(pgrep pidgin |sed 1q )/environ)
# set debus
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && 
  export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus # probably always this

# disable-reenable accounts using python+dbus
$(dirname $0)/restart-pidgin-slack-dbus.py
## or just restart everything
# if only one window, kill and restart
# otherwise,prompt to kill and restart
# test $(wmctrl -xl|grep Pidgin.Pidgin|wc -l) -le 1 || yad --text "ready to restart pidgin?" --splash && killall pidgin && pidgin &
