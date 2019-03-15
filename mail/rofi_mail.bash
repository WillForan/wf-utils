#!/usr/bin/env bash
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

#
# search mail with rofi, launch with emacs
#

s="$(rofi -p "search" -dmenu)"

notmuch search  $s|
   rofi -dmenu|
   cut -f1 -d' '|
   xargs -r -n1 -I{} \
   emacsclient -c -eval  \
         "(progn 
           (notmuch-search \"{}\") (flyspell-mode 1)
           (notmuch-tree-from-search-current-query)
           (sleep-for 0 200)
           (notmuch-tree-show-message-in))"

