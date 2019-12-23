#!/bin/bash

filename=`basename "$1"`
filedir=`dirname "$1"`

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

# move into compile directory
originalDir=`pwd`
cd "$filedir"

cat "$originalDir/ignored-words.en.pws.editable" | grep -v -e '^$' | grep -v -e '^#' > "$originalDir/ignored-words.en.pws"

aspell -t -c \
	--dont-tex-check-comments \
	--add-tex-command="citep op" \
	--personal="$originalDir/ignored-words.en.pws" \
	"$filename"
