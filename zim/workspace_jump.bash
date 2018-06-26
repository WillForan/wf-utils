#!/usr/bin/env bash

# jump to zim if active workspace matches a file
ws=$(i3-msg -t get_workspaces|jq -r 'map(select(.visible)) | .[] |.name'  | grep -v '^[0-9]'|sed 1q)
[ -z "$ws" ] && echo "no worksapces" && exit 1

source $(dirname $0)/quickjump_src.bash

read notebookdir notebookname <<< $(getnotebook $1)

zimpath=$(echo $ws | pathtouri )
[ ! -z "$zimpath" ] && echo "$ws cannot be made into zimpath" && exit 1
filepath=$notebookdir/$zimpath
[ ! -r "$filepath" ] && echo "$zimpath DNE as $filepath!?" && exit 1
gotozim $zimpath $notebookname $filepath
