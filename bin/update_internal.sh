rm -fv filter_internal_traffic

echo -n "ipgrep -v -m " > filter_internal_traffic

egrep -v '^#' internal_subnets.txt | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' >> filter_internal_traffic

chmod +x filter_internal_traffic
