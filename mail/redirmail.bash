#!/usr/bin/env bash

# generalize
# notmuch search --output=files $@ | grep $MAILDIR | xargs -r -I{} mv {} ~/Maildir/LocalArchive/it/notifications/cur/

MAILDIR=$HOME/Maildir
MAKEDIR="" # dont make directories that dont exist

# usage: findmail from:foranw "disk usage"
findmail(){ notmuch search --output=files $@ | grep "$MAILDIR/new";}

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
 notmuch tag +archive $@ 
 findmail $@ | movemail $dest
}

mbsync -a
notmuch new
filterto "LocalArchive/it/notifications" from:foranw "disk usage"
filterto "LocalArchive/mlists/all"       to:mne_analysis 
filterto "LocalArchive/junk/all"         from:announcements@info.sagepub.co.uk
filterto "LocalArchive/it/netvault"      "netvault: Job completed successfully"
filterto "LocalArchive/upmc/spam"        from:DailyExtra@upmc.edu 
notmuch new
notmuch tag +archive -- not tag:archive and from:cron 

# search for 1 minute more than cron is set for (5min)
# open in emacs, use i3 rule to focus on workspace
nmf() { notmuch show --body=false --format=json $1 |jq -r '.[0]|.[0]|.[0].headers.From'|sed 's/".*" *//;s/[<>]//g'; }
emacs_mail(){
   # emacs -f NotMuch
   DISPLAY=:0 \
   emacsclient -c -a "" -eval  \
      "(progn (setq frame-title-format \"NEWMAIL $(date +%FT%H:%M) $(nmf $1)\") (notmuch) (flyspell-mode 1)  (notmuch-show \"$1\")  )"
}
mail_to_read(){ notmuch search --output=threads date:"6min..now" tag:unread -tag:archive; }
export -f nmf emacs_mail
mail_to_read | parallel -n1 emacs_mail {}
