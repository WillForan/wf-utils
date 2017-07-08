#!/usr/bin/env bash

# use notebook txt filelist, zim plugin quickjump.py, and rofi to jump to a file
# combine with zim wiki -> i3 worksapce parser (../i3/zim-i3-go.bash)
#
# ideal for xkeybind, sxhkd, windows manager hot keys, etc
notebooklistfile=~/.config/zim/notebooks.list 
notebookDirAndName(){ 
  perl -F= -sne '
   $F[1]=~s/~/$ENV{HOME}/; chomp($F[1]);
   print "$F[1] " if $F[0] =~ /uri|name/;
   print "\n" if /name/;' $notebooklistfile
}

findinnotebook() {
  find -L $1 \
    -iname '*txt' \
    -not -iname '*-conflict-*' \
    -not -iname '* conflicted copy *' \
    -printf '%P\n'
}
uritopath(){ sed 's!/!:!g;s/.txt$//;'; }
pathtouri(){ sed 's!:!/!g;s/$/.txt/;'; }
menu()     { rofi -dmenu  -i -matching glob; }

# either we give a notebook
# or we take the first one in the .list file
# N.B. if searchstr is empty (no args) grep empty returns all
set -x
searchstr="$1"; 
read notebookdir notebookname <<< $(notebookDirAndName|egrep -i "$searchstr" |sed 1q)
[ -z "$notebookdir" ] && echo "no notebooks" && exit 1


# list all the txt files in this notebook and pick one
zimpath=$(findinnotebook $notebookdir | uritopath | menu )
[ -z "$zimpath" ] && exit # escaped menu, nothing to do

filepath=$notebookdir/$(echo $zimpath | pathtouri )
[ ! -r "$filepath" ] && echo "$zimpath DNE as $filepath!?" && exit 1

zim --plugin quickjump $zimpath $notebookname
$(dirname $0)/../i3/zim-i3-go.bash $zimpath $filepath


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
