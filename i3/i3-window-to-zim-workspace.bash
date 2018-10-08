#!/usr/bin/env bash
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT
cd $(dirname $0)

#
# move to a window to a workspace based on zim directory tree
# e.g.  IT:WFSetup
#

source ../zim/quickjump_src.bash # findinnotebook, getnotebook, gotozim

read notebookdir notebookname <<< $(getnotebook $1)
zimpath=$(findinnotebook $notebookdir | uritopath | menu )
[ -z "$zimpath" ] && exit

i3-msg move container to workspace "$zimpath"
i3-msg workspace "$zimpath"

zim --plugin quickjump $zimpath $notebookname &
