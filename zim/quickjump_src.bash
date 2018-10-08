#!/usr/bin/env bash

# ideal for xkeybind, sxhkd, windows manager hot keys, etc
GOTOZIMSCRIPTDIR=$(cd $(dirname $BASH_SOURCE);pwd)
NOTEBOOKLISTFILE=~/.config/zim/notebooks.list 
notebookDirAndName(){ 
  perl -F= -sne '
   $F[1]=~s/~/$ENV{HOME}/; chomp($F[1]);
   print "$F[1] " if $F[0] =~ /uri|name/;
   print "\n" if /name/;' $NOTEBOOKLISTFILE
}
uritopath(){ sed 's!/!:!g;s/.txt$//;'; }
pathtouri(){ sed 's!:!/!g;s/$/.txt/;'; }
menu()     { rofi -dmenu  -i -matching glob; }

# list all the txt files in this notebook and pick one
getnotebook(){
  local notebooksearchstr="$1"; 
  read notebookdir notebookname <<< $(notebookDirAndName|egrep -i "$notebooksearchstr" |sed 1q)
  [ -z "$notebookdir" ] && echo "no notebooks" && exit 1
  echo $notebookdir $notebookname
}

gotozim(){
  local zimpath="$1"; shift
  local notebookname="$1"; shift
  local filepath="$1"; shift
  # still have argtuments, probalby dont want to jump
  [ $# -ge 1 ] && i3jump=0 || i3jump=1
  # go to zim window if we have it
  wmctrl -l|grep " - Zim$"| sed 1q | cut -f1 -d' '|xargs -r wmctrl -i -a
  # move zim to the page we reqested
  zim --plugin quickjump $zimpath $notebookname &
  # go to the desktop of the page we are editing
  [ $i3jump -eq 1 ] && $GOTOZIMSCRIPTDIR/../i3/zim-i3-go.bash $zimpath $filepath
  return 0
}

findinnotebook() {
  find -L $1 \
    -iname '*txt' \
    -not -iname '*-conflict-*' \
    -not -iname '* conflicted copy *' \
    -printf '%P\n'
}
