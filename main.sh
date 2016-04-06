#! /bin/bash

# Parses command Arguments
while [[ $# > 1 ]]
do
key="$1"

case $key in
	-d|--directory)
	DIRECTORY="$2"
	shift
	;;
	-e|--extension)
	EXTENSION="$2"
	shift
	;;
	-i|--dictionary)
	DICTIONARY="$2"
	shift
	;;
esac
shift
done

if [ ! "$EXTENSION" ]; then
	EXTENSION=".docx"
fi

if [ ! "$DIRECTORY" ]; then
	DIRECTORY=$(pwd)
fi

if [ ! "$DICTIONARY" ]; then
    echo "-i|--dictionary must be specified"
    exit 1
fi

#
# Checks if valid dir passed
#
if [ ! -d $DIRECTORY ]; then
  echo "Invalid Directory"
  exit 1
fi

# Checks has ending "/" adds it if not
case "$DIRECTORY" in
	*/)
	;;
	*)
	DIRECTORY=$DIRECTORY/
	;;
esac

#
# File expansion get all "docx" files on a dir
#
FILES=$DIRECTORY"*$EXTENSION"

# Check if files found
if [ -z "$FILES" ] || [ $FILES == $DIRECTORY*$EXTENSION ]; then
  echo "No files found"
  exit 1
fi

#
# Main loop
#
# Iterates through files
#
DOCUMENT="word/document.xml"
for f in $FILES
do
    echo ""
    echo "## Prosesing file: $f"
    echo "-> Unziping \"$DOCUMENT\""
    echo "-> unzip $f $DOCUMENT"
    unzip "$f" "$DOCUMENT"
    
    echo "-> Substitute strings in dictionary on file TODO"
    echo "-> replacer $DOCUMENT $DICTIONARY"
    replacer "$DOCUMENT" "$DICTIONARY"
    
    echo "-> Update $DOCUMENT on the $EXTENSION file"
    echo "-> zip -f $f $DOCUMENT"
    zip -f "$f" $DOCUMENT
    
    echo "-> Delete \"$DOCUMENT\" modified"
    echo "rm $DOCUMENT"
    rm $DOCUMENT

    echo "##"
    echo ""
done
rmdir "word/"

