#!/usr/bin/env bash

##
# go to a zim page from i3 active workspace 
# - takes no inputs
##

#  i3 to get all workspaces
#  xdotool to get active  # ws=$(i3-msg -t get_workspaces|jq -r 'map(select(.visible)) | .[] |.name'  | grep -v '^[0-9]'|sed 1q)
#  jq to get i3 name      # could just use jq with above
#  zim bash functions to find notebook and go to path

thisdir=$(cd $(dirname $0);pwd)
source $thisdir/../zim/quickjump_src.bash

gotozim $(i3-msg -t get_workspaces|jq ".[$(xdotool get_desktop)].name"|uritopath)  $(getnotebook)
