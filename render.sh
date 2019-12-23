#!/bin/bash

filename=`basename "$1"`
filenameNoTex=`echo "$filename" | sed 's/\.tex//'`
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
cd "$filedir"

# compile
xelatex "$filename"
makeglossaries "$filenameNoTex"
xeltex "$filename"
bibtex "$filenameNoTex"
xelatex "$filename"
xelatex "$filename"

# word count
echo "$filename has $(cat $filename | sed 's/citep{[a-zA-Z0-9,]*}//ig' | detex | wc -w) words"

# clean-up
rm *.aux *.bak *.bbl *.blg *.glg *.glo *.gls *.idx *.ist *.log *.toc > /dev/null 2>&1
