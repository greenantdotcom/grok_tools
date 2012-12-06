## Install grok via `homebrew` ##

	brew install grok

## Put log files where you want them ##

The default scripts assume a `/logs/` directory on your filesystem, but you can place the logs anywhere.

When referencing logs, you will need to set the input file for grok to use in the config like so:

	exec "cat /logs/webserver1_05nov_access_log"

Change the invocation of exec to include whichever file(s) you wish to process.

## Run the various .grok.conf files ##

	grok -f default.grok.conf
	grok -f ua.grok.conf
	grok -f ip.grok.conf

## Creating your own .grok.conf file ##

Feel free to duplicate any of the files and name it something else. After duplicating it, look for this section:

	# the reaction is what to emit on a match
    reaction: "%{clientip}"

And replace it with the values you wish to output. You can output multiple values if you like, like so (client IP and request type with a tab in between):

	# the reaction is what to emit on a match
    reaction: "%{clientip}	%{verb}"

## Fields which you can output in grok ##

| Key | Description |
| --- | --- |
| ARESWEBLOGFULL | Full input line
| timestamp | Full Apache timestamp
| MONTHDAY | Day of month |
| TIME | Time (hh:mm:ss) |
| HOUR | |
| MINUTE | |
| SECOND | |
| ZONE | Timezone offset |
| verb | Request type (HEAD\|GET\|POST) |
| request | Full requested URI incl. query string |
| clientip | Requesting IP address |
| response | HTTP Response Code |
| agent | HTTP User agent |
| referer | HTTP Referer |
| bytes | Bytes served |
| hostname | Requested hostname |

### Example grok output line

	"APACHEREQUESTDETAILS"=> ["\"GET /js/_default/ARESbot.js?bundle=visitlex-2012&nc=1 HTTP/1.1\""],
	"WORD:verb"=>["GET"],
	"URIPATHPARAM:request"=>["/js/_default/ARESbot.js?bundle=visitlex-2012&nc=1"],
	"URIPATH"=>["/js/_default/ARESbot.js", "/whattodo/attractions.php"],
	"URIPARAM"=>["?bundle=visitlex-2012&nc=1", "?page=3&"],
	"NUMBER:httpversion"=>["1.1"],
	"BASE10NUM"=>["1.1", "200", "13206"],
	"IPORHOST:hostname"=>["arestravel.com"],
	"HOSTNAME"=>["arestravel.com", "127.0.0.1", "www.visitlex.com"],
	"IP"=>["", "", ""],
	"NUMBER:response"=>["200"],
	"NUMBER:bytes"=>["13206"],
	"IPORHOST:clientip"=>["127.0.0.1"],
	"QS:agent"=>
	 ["\"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4\""],
	"QUOTEDSTRING"=>
	 ["\"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4\"",
	  "",
	  "\"-\""],
	"URI:referrer"=>["http://www.visitlex.com/whattodo/attractions.php?page=3&"],
	"URIPROTO"=>["http"],
	"USER"=>[""],
	"USERNAME"=>[""],
	"URIHOST"=>["www.visitlex.com"],
	"IPORHOST"=>["www.visitlex.com"],
	"POSINT:port"=>[""],
	"URIPATHPARAM"=>["/whattodo/attractions.php?page=3&"],
	"QS:referrer"=>[""],
	"QS:cookie"=>["\"-\""]}

## Piecing it all together ##

### Showing all IP addresses 

	grok -f ip_with_req.grok.conf | bin/filter_internal_traffic | awk '{ print $2 }' | sort -n | uniq -c | sort -nr | head -n 40

### Show all IP Addresses for requests for any page where checkInDate is passed in and contains a non-default checkInDate ###

	grok -f ip_with_req.grok.conf | bin/filter_internal_traffic | grep checkInDate | grep -v checkInDate=mm | awk '{print $2}' | sort -n | uniq -c | sort -nr | head -n 40

### Show all IP Addresses for requests for any page over certain hours ###

	grok -f ip_with_req.grok.conf | bin/filter_internal_traffic | egrep '^(09|10)' | awk '{print $2}' | sort -n | uniq -c | sort -nr | head -n 40

### Show which site was requested the most during the day ###

	grok -f hostnames.conf | sort -n | uniq -c | sort -nr | head -n 40
	
