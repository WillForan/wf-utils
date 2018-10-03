#!/usr/bin/env bash
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

#
# go to converstation window in pidgin
# NB. multiple convo windows are tabs handled by i3, not by pidgin!
#

~/src/utils/wf-utils/pidgin-start-conv.py  | rofi -dmenu -i | while IFS=$'\t' read id im_alias; do
   ~/src/utils/wf-utils/pidgin-start-conv.py $im_alias
   wmctrl -Fa "${id%%@*}"
done
