# open an mail thread in notmuch with emacs
# usage notmuch search date:5min...now from:will | parallel ethread
ethread(){
   # emacs -f NotMuch
   emacsclient -c -eval  \
      "(progn    (notmuch-search \"$1\") (flyspell-mode 1) (notmuch-tree-from-search-current-query) (sleep-for 0 200) (notmuch-tree-show-message-in))"
}
