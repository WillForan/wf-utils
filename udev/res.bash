#!/usr/bin/env bash
# 20170907 -- WF
# use a hdmi monitor if it's plugged in
#  - copied from https://frdmtoplay.com/i3-udev-xrandr-hotplugging-output-switching/
#  - called from /etc/udev/rules.d/98-HDMIin.rules w/ENV{XAUTHORITY}
#     KERNEL=="card0", SUBSYSTEM=="drm", ACTION=="change", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/foranw/.Xauthority", RUN+="/home/foranw/src/wf-utils/udev/res.bash" 
#
# check udev status with
#   sudo udevadm monitor
#    KERNEL[142497.160304] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
#    UDEV  [142497.161306] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)

# some debugging info
#set -e
#trap 'echo "[$(date) $(whoami)] $monstat $nworkspace " >> /tmp/hdmihot.log' EXIT


# some assumptions
export DISPLAY=:0
export XAUTHORITY=/home/foranw/.Xauthority 

# system status
monstat=$(</sys/class/drm/card0/card0-HDMI-A-1/status) 
nworkspace=$(i3-msg -t get_workspaces|jq '[.[]|.output]|sort|unique|length') 

# what to do about it
case $monstat in 
 connected)  
    #echo "turn on the lights" >> /tmp/hdmihot.log
    xrandr #>> /tmp/hdmihot.log
    #sleep 1 # takes a second for the screen to register
    xrandr --output HDMI-1 --right-of LVDS-1 --auto;;
 disconnected)  
    #echo "lights out " >> /tmp/hdmihot.log
    xrandr --output HDMI-1 --off;;
esac
