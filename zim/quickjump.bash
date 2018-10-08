#!/usr/bin/env bash

# use notebook txt filelist, zim plugin quickjump.py, and rofi to jump to a file
# combine with zim wiki -> i3 worksapce parser (../i3/zim-i3-go.bash)
#
# ideal for xkeybind, sxhkd, windows manager hot keys, etc

source $(dirname $0)/quickjump_src.bash


# either we give a notebook
# or we take the first one in the .list file
# N.B. if searchstr is empty (no args) grep empty returns all
set -x

read notebookdir notebookname <<< $(getnotebook $1)

# list all the txt files in this notebook and pick one
zimpath=$(findinnotebook $notebookdir | uritopath | menu )
[ -z "$zimpath" ] && exit # escaped menu, nothing to do

filepath=$notebookdir/$(echo $zimpath | pathtouri )
[ ! -r "$filepath" ] && echo "$zimpath DNE as $filepath!?" && exit 1


gotozim $zimpath $notebookname $filepath

#  as "one-liner"
# grep uri ~/.config/zim/notebooks.list|
#  sed "s/.*=//;s:~:$HOME:;1q" |
#  xargs -I{}  find -L {} \
#    -iname '*txt' \
#    -not -iname '*-conflict-*' \
#    -not -iname '* conflicted copy *' \
#    -printf '%P\n' |
#  sed 's!/!:!g;s/.txt$//;' |
#  rofi -dmenu  -i -matching glob  |
#  xargs  ~/.local/bin/zim --plugin quickjump
