#!/usr/bin/env bash

# 2017-07-17 - search for pidgin alias (assume focused window title) in notebook and jump to there
! which rg >/dev/null && export PATH="$PATH:$HOME/.cargo/bin"
source $(dirname $0)/quickjump_src.bash

read notebookdir notebookname <<< $(getnotebook $1)
findinnotebook() { rg -i -l $2 -g '!Calendar' $1 | sed "s:$1::g"; }

class="$(xprop -id $(xdotool getactivewindow ) WM_CLASS)"
case "$class" in
   *Pidgin*)
      person="@$(xdotool getactivewindow getwindowname)"
      zimpath=$(findinnotebook $notebookdir $person | uritopath | menu )
      noi3jump=""
      ;;
   *term*|*urxvt*)
      directory="$(xdotool getactivewindow getwindowname|cut -f2 -d:|
          perl -F/ -slane 'print join "/", @F[0..$#F-$_] for (0..$#F-1)'|menu)"
      [ -z "$directory" ] && exit
      zimpath=$(findinnotebook $notebookdir $directory | uritopath | menu )
      echo "set no i3jump"
      noi3jump="nojump"
      ;;
   *)
     echo "unknown class $class" >&2;
     exit 1
     ;;
esac
[ -z "$zimpath" ] && exit # escaped menu, nothing to do

filepath=$notebookdir/$(echo $zimpath | pathtouri )
[ ! -r "$filepath" ] && echo "$zimpath DNE as $filepath!?" && exit 1
gotozim $zimpath $notebookname $filepath $noi3jump
