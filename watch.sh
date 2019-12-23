#!/bin/bash

filenamewithpath="$1"
filename=`basename "$1"`

# check location
pwd | grep -qE "/latex$"
if [[ $? != 0 ]]; then
	echo "ERROR: This script must be ran from inside the 'latex' folder"
	exit 1
fi

# check input
echo "$filename" | grep -qE "\.tex$"
if [[ $? != 0 ]]; then
	echo "ERROR: File name must end in .tex"
	exit 1
fi

# start watch loop
echo "Watching $filename for changes..."
while inotifywait -q -e close_write "$filenamewithpath"; do
	sh render.sh "$filenamewithpath"

	echo "-----------"
	echo "Watching $filename for changes..."
done
