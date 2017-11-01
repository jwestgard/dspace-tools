#!/usr/bin/env bash

#==============================================================================
#
#         FILE:  import-setup.sh
#        USAGE:  import-setup.sh [file] [handle]
#  DESCRIPTION:  Given a file or directory path and DSpace handle, set up the
#                directories and files needed for adding the files to the 
#                existing object denoted by the handle using the dspace 
#                itemupdate command.
#       AUTHOR:  Joshua A. Westgard
#      CREATED:  2017.11.01
#      VERSION:  2
#
#==============================================================================

FILEPATH=$1
HANDLE=$2
BATCHDIR="load$(date +%Y%m%d)"
DC="$BATCHDIR/item_1/dublin_core.xml"

if [[ -e $BATCHDIR ]]; then
    echo "Output directory exists. Exiting..."
    exit 1
fi


#----------------------------------------------------------------------
# set up SAF package structure
#----------------------------------------------------------------------
echo "Creating SAF package to attach bitstreams to $HANDLE ..."
mkdir -p "$BATCHDIR/item_1" && echo "  - created output dirs;"
touch "$BATCHDIR/item_1/contents" && echo "  - created contents file;"
echo $HANDLE >> "$BATCHDIR/item_1/handle" && echo "  - created handle file;"


#----------------------------------------------------------------------
# move file or files into position inside SAF directories
#----------------------------------------------------------------------
echo "Checking $FILEPATH ..."
if [[ -f $FILEPATH ]]; then
    echo "  - $FILEPATH is a single file."
    exit 0
else
    if [[ -d "$FILEPATH" ]]; then
        echo "  - $FILEPATH is a directory; moving files:"
        count=1
        for item in "$FILEPATH"/*; do
            if [[ -f $item ]]; then
                mv $item "$BATCHDIR/item_1" && 
                  echo "    $count. Moving $item"
                echo $(basename "$item") >> "$BATCHDIR/item_1/contents" && 
                  echo "      - appending filename to contents list."
                (( count += 1 ))
            fi
        done
    fi 
fi


#----------------------------------------------------------------------
# create minimal dublin_core.xml containing URL of obj to be updated
#----------------------------------------------------------------------
echo "Creating dublin_core.xml"
echo '<?xml version="1.0" encoding="utf-8" standalone="no"?>' > "$DC"
echo '<dublin_core schema="dc">' >> "$DC"
echo "  <dcvalue element=\"identifier\"\
 qualifier=\"uri\">$HANDLE</dcvalue>" >> "$DC"
echo '</dublin_core>' >> "$DC"
echo "Done."
