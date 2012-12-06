rm -fv filter_spiders

echo -n "ipgrep -v -m " > filter_spiders

curl -A 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Firefox/17.0' http://www.iplists.com/google.txt http://www.iplists.com/inktomi.txt | egrep -v '^#' | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' >> filter_spiders

chmod +x filter_spiders
