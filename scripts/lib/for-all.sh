#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Run script for all clusters"
    echo
    echo "      $0 DIRECTORY SCRIPT"
    echo
    echo "Runs the script once for each file in the given directory."
    echo "Will start the script in the current directory, with the file location as the first parameter and the filename as the second parameter"
    echo
    echo "Example:  $0 . echo"
    exit -1
fi

DIRECTORY=$1
SCRIPT=$2

for i in $(ls $1); do
    $2 $1/$i $i
done
