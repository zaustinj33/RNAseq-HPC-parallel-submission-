#!/bin/bash

## NOTE raw_data with unzipped data must be present for submission to work

# Usage: ./01_submit.sh <Txt File with list of data> <Absolute path to directory>

DIR=$PWD/raw_data

if [ -d "$DIR" ]; then
    cat $1 | while read LINE
	do
	sh ./02_RNAseq_STAR_ZJ.sh $LINE $2
done
fi
echo 'raw_data directory does not exist in this directory'


