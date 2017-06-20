#!/usr/bin/env bash

# generalize
# notmuch search --output=files $@ | grep $MAILDIR | xargs -r -I{} mv {} ~/Maildir/LocalArchive/it/notifications/cur/

MAILDIR=$HOME/Maildir
MAKEDIR="" # dont make directories that dont exist

# usage: findmail from:foranw "disk usage"
findmail(){ notmuch search --output=files $@ | grep "$MAILDIR/cur";}

movemail_() { xargs -r -I{} mv {} $1; }
#findmail from:foranw disk\ usage | movemail_ ~/Maildir/LocalArchive/it/notifications/cur/

movemail(){ 
   dest="$1"
   [ -z "$dest" ] && continue
   [[ ! "$dest" =~ cur/?$ ]] && dest=$dest/cur
   [[ ! "$dest" =~ ^$MAILDIR ]] && dest=$MAILDIR/$dest
   [ ! -d "$dest" -a -n "$MAKEDIR" ] && mkdir -p $d
   [ ! -d "$dest" ] && echo "$dest DNE" >&2 && return 1
   movemail_ "$dest"
}

# usage: filterto "LocalArchive/it/notifications" from:foranw "disk usage"
filterto(){
 [ -z "$2" ] && echo "USAGE: filterto directory search terms" >&2 && return 1
 dest=$1; shift
 findmail $@ | movemail $dest
}

mbsync -a
notmuch new
filterto "LocalArchive/it/notifications" from:foranw "disk usage"
filterto "LocalArchive/mlists/all" to:mne_analysis 
filterto "LocalArchive/it/netvault" "netvault: Job completed successfully"
filterto "LocalArchive/upmc/spam" from:DailyExtra@upmc.edu 
notmuch new
