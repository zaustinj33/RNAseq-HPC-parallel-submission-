#!/bin/bash
## Grab conversion rate statistic from slurm output files of meRanT ##


#for FILE in <path-to-slurmOutput>/slurm*

#my data
for FILE in $PWD/Code/*/slurm* 
do
	result=${FILE%/slurm*} #path without filename
	result="${result%"${result##*[!/]}"}" #trim all trailing /'s
	result="${result##*/}"  #remove all text before last /
	echo -e "$result \t" >> conversion_rates.txt
	grep -E 'Total reads processed'| >> conversion_rates.txt # add any line in quotes to grab data for all files 
	echo -e "\n" >> conversion_rates.txt
done
