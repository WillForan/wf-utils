#!/usr/bin/env bash
#
#
# take a markdown from stdin, boundary text from the first argument 
# and spit out a multipart text+html document sutable for email (esp. via mutt)
#
#  USAGE:
#  ## .muttrc (Alt+5 to launch)
#    my_boundarycutter=`openssl rand -hex 24`
#    macro compose \e5 "F sendmarkdown $my_boundarycutter \ny^T^Umultipart/alternative;boundary=$my_boundarycutter\n"
#
#  ## CLI
#
#   (b=$(openssl rand -hex 24); 
#    echo -e "Content-type: multipart/alternative; boundary=$b\r\nSubject: test";
#    echo -e '# markdown\n* looks\n* like\n* `this`'| ./sendmarkdown.bash $b;
#   ) | msmtp you@domain.com

#
#
# NB. first content type is not set. expected to be done in mutt
#  Content-type: multipart/alternative; boundary=$boundarycut
#  
#
# refs
#  https://stackoverflow.com/questions/3508338/what-is-the-boundary-in-multipart-form-data
#  https://stackoverflow.com/questions/17398636/how-can-i-send-a-mail-from-unix-mutt-client-with-both-html-and-body-in-html
#  https://stackoverflow.com/questions/18516665/php-mime-multipart-mail


boundarycut="$1"
tmp=$(mktemp /tmp/mailXXXX)
cat > $tmp

# if we were given bad data we should warning
# but also return input so as not to clear it in mutt
if [ -z "$boundarycut" ] || grep "$boundarycut" $tmp >/dev/null; then
 echo "boundary text '$boundarycut' is empty or also in message!" >&2 
 cat $tmp 
 exit 1
fi

part(){ echo -e "--$boundarycut\nContent-Type: text/$1; charset=ISO-8859-1\r\n";}

part plain 
cat $tmp

part html
lowdown $tmp
#echo "--$boundarycut"

