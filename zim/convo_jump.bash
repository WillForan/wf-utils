#!/usr/bin/env bash

# 2017-07-17 - search for pidgin alias (assume focused window title) in notebook and jump to there
! which rg >/dev/null && export PATH="$PATH:$HOME/.cargo/bin"
source $(dirname $0)/quickjump_src.bash

read notebookdir notebookname <<< $(getnotebook $1)
findinnotebook() { rg -i -l $2 -g '!Calendar' $1 | sed "s:$1::g"; }

person="@$(xdotool getactivewindow getwindowname)"
zimpath=$(findinnotebook $notebookdir $person | uritopath | menu )
[ -z "$zimpath" ] && exit # escaped menu, nothing to do

filepath=$notebookdir/$(echo $zimpath | pathtouri )
[ ! -r "$filepath" ] && echo "$zimpath DNE as $filepath!?" && exit 1
gotozim $zimpath $notebookname $filepath
