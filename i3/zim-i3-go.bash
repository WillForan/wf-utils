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
 [ -z "$1" -o ! -r "$1" ] && xmessage "no file $1" && return
 grep '^ws::term' "$1" | while IFS=: read wsjunk empty term host dir; do
  if [ -n "$host" ]; then 
     cmd="ssh $host -t 'cd $dir; exec \$SHELL -l'"
     #xmessage "$TERM -e \"$cmd\""
     $TERM -e "$cmd" &
  else
     #xmessage "'$wsjusnk' '$empty' '$term' '$host' '$dir'"
     cd $dir
     $TERM &
  fi
 done
}

# does the workspace already exist
exists=
i3-msg -t get_workspaces|jq  '.[].name'|grep -l "$pagename" && exists=1

i3-msg workspace "$pagename"
if [ -z "$exists" ]; then
 i3-msg move workspace to output left
 #$TERM -e "cat $pagefile && read" &
 termstoplaces "$pagefile" 
fi

