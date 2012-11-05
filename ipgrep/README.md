## Source ##

- http://staff.washington.edu/dittrich/talks/core02/tools/tools.html

## Usage ##

### Find all lines including internal IP addresses

	ipgrep -m 10.100.2.0/24,10.50.0.0/16,127.0.0.1

### Find all lines _not_ including internal IP addresses ###

	ipgrep -v -m 10.100.2.0/24,10.50.0.0/16,127.0.0.1
