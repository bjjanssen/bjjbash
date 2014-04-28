#!/usr/bin/env bash

# Remove old Directories
# Last edit 2014-04-28 bjoern.janssen

TARGETDIR=$(pwd)                        	# Set directory to clean up. Default is current working directory.
REFDATE=$(stat -c %Y ~/foo | cut -f1 -d" ")	# Set file you want to use as reference date provider. 
let "EXPIRE=60*60*24*3"				# Set expiration time (seconds*minutes*hours*days). The default equals 259200 seconds, ie three days.

cd $TARGETDIR
find . -mindepth 1 -maxdepth 1 -type d -print0 | while read -r -d '' dir; do 
	DIRMTIME=$(stat -c %Y $dir | cut -f1 -d" ")
	let "DIRAGE=$REFDATE-$DIRMTIME"
	if [[ $DIRAGE -gt $EXPIRE ]]; then 
		echo rm -rf $dir
	fi
done
