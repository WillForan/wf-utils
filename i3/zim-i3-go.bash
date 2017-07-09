#!/usr/bin/env bash

# add custom tool to zim
# with command 
# /home/foranw/src/utils/wf-utils/ zim-i3-go.bash "%p" "%n"

pagename="$1"
pagefile="$2"
[ -z "$pagename" ] && exit

#[ -z "$TERM" ] && TERM=uxterm
TERM=uxterm
# look for lines like ws::term:r:/opt/ni_tools/MIPAV
termstoplaces() {
 host=$1; shift
 dir=$1; shift
 if [ -n "$host" ]; then 
    cmd="ssh $host -t 'cd $dir; exec \$SHELL -l'"
    #xmessage "$TERM -e \"$cmd\""
    $TERM -e "$cmd" &
 else
    #xmessage "'$wsjusnk' '$empty' '$term' '$host' '$dir'"
    cd $dir
    $TERM &
 fi
}

parseallws() {
 [ -z "$1" -o ! -r "$1" ] && return
 egrep '^ws::(org|edit|term)' "$1" | while IFS=: read leader empty action host arg; do
   echo "running: '$action' on host '$host' with '$arg'"
   case $action in
      edit)
         [ -n "$host" ] && (xmessage "cannot deal with hosts for edit" &) && continue
         [ -z "$arg" -o ! -r "$arg" ] && continue
         $TERM -e "vim $arg" &
         ;;
      org)
        [ -n "$host" ] && arg="/$host:/$arg"
        #[ -z "$host" -a ! -r $arg ] && continue
        emacs $arg &
      ;;
      term)
         termstoplaces "$host" "$arg"
      ;;
      *) xmessage "dont know what to do with $action" & 
      ;;
   esac
 done
}

# does the workspace already exist
exists=
i3-msg -t get_workspaces|jq  '.[].name'|grep -l "$pagename" && exists=1

i3-msg workspace "$pagename"
if [ -z "$exists" ]; then
 i3-msg move workspace to output left
 [ -z "$pagefile" -o ! -r "$pagefile" ] && xmessage "no file $pagefile" && exit 1
 #$TERM -e "cat $pagefile && read" &
 parseallws "$pagefile"
else 
   echo "already have desktop"
fi

