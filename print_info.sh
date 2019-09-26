#!/bin/bash
set -e
CURL=$(command -v curl)
CURLOPTS="-sL" 
API="https://api.darksky.net/forecast"
KEY="c8c0ec94812d772a89fa95f08d254575"
LAT="${LATITUDE:-48.2351407}"
LON="${LONGITUDE:-16.416102}"
INFOS="TEMP:.currently.temperature HUMIDITY:.currently.humidity"
REFRESH=${REFRESH:-30}
TTYS=${TTYS:-/dev/tty1}
die(){
  echo "I NEED TO GO"
  kill %1
  exit $1
}

# set trap and call die()
trap 'die' 1 2 3 15

function fetch_data {
	while true; do
		$CURL $CURLOPTS $API/$KEY/$LAT,$LON  > /tmp/data_tmp.json
		if [ $? -eq 0 ]; then 
			mv  /tmp/data_tmp.json /tmp/data.json
		fi
		sleep $REFRESH
	done
}

function clean() {
	a=0
	while [ $a -lt  80 ]; do	
		echo '' > $TTYS
		((a++))
	done
}
function main() {
	while true; do
		clean
		(
			for VAL in $INFOS; do
				name=$(echo $VAL|awk -F: '{print $1}')
				stat=$(echo $VAL|awk -F: '{print $2}')
				val=$(cat /tmp/data.json | jq $stat)	
				echo ${name}: $val	
			done
		) | lolcat |tee $TTYS
		sleep 1
	done
}	
fetch_data &
clean
main