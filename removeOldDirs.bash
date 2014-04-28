#!/usr/bin/env bash

# Remove old Directories
# Last edit 2014-04-28 bjoern.janssen

# Common scenario:
# You want to delete a bunch of old directories (or files)
# but you want to measure the age of the delete candidate against 
# a specific file or a specific date. In this situation find's diverse -xtime or
# -not -newer options are not cutting it. 
#
# In this simple script you set a reference date in seconds since UNIX time began 
# and compare your delete candidates' time stamp in seconds since UNIX time began
# against an expiration date. 
#
# It should be obvious how to modify this script for use on files or 
# how to make it parametrized for direct CLI usage.

TARGETDIR=$(pwd)                        	# Set directory to clean up. Default is current working directory.
REFDATE=$(stat -c %Y ~/foo)	# Set file you want to use as reference date provider. 
let "EXPIRE=60*60*24*3"				# Set expiration time (seconds*minutes*hours*days). The default equals 259200 seconds, ie three days.

cd $TARGETDIR
find . -mindepth 1 -maxdepth 1 -type d -print0 | while read -r -d '' dir; do 
	DIRMTIME=$(stat -c %Y $dir)
	let "DIRAGE=$REFDATE-$DIRMTIME"
	if [[ $DIRAGE -gt $EXPIRE ]]; then 
		echo rm -rf $dir
	fi
done
