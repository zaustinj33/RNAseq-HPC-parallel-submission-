#!/bin/bash/
# Append names of raw read files in BS folders to list.txt for running future scripts

#need to add if statement option for .gz or .fq files

for f in $PWD/raw_data/*/*fq
do 
        f=${f##*/}
	f=${f%_[0-9].fq}
        echo $f >> prelist.txt
done
# delete every other line (2nd replicates)
sed '2~2d' $PWD/prelist.txt > list.txt
rm prelist.txt




