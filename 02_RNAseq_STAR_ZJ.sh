#!/bin/bash

mkdir -p $2/Code
mkdir -p $2/result
mkdir -p $2/Code/$1
mkdir -p $2/result/$1
mkdir -p $2/working_data
mkdir -p $2/working_data/$1

## Note: be sure to 1) unzip raw data files, and 2) generate list.txt first
# Set reusable paths 
IDX=~/KCl_RNAseq/raw_data/Index/Mouse_STAR-2.5.3a_index
GNM=~/KCl_RNAseq/raw_data/Index/Mus_musculus.GRCm38.dna.primary_assembly.fa
GTF=~/KCl_RNAseq/raw_data/Index/Mus_musculus.GRCm38.99.gtf

pushd $2/Code/$1

echo -e "#!/bin/bash
#SBATCH -p --
#SBATCH -A --
#SBATCH --nodes=1 --ntasks-per-node=16
# SBATCH --mem=64000
# SBATCH --mem-per-cpu=32000
#SBATCH --exclusive
#SBATCH --time=100:00:00
#SBATCH --mail-user zaustinj@vt.edu
#SBATCH --mail-type=END
" >> $1_STARmap.sbatch

# Add necessary modules
echo -e "
module purge
. /etc/profile.d/user-default-modules.sh
module add FastQC/0.11.7-Java-1.8.0_162
module add Trim_Galore/0.5.0-foss-2018a cutadapt/1.17-foss-2018a-Python-3.6.4
\n" >> $1_STARmap.sbatch 

# Change to raw data directory
echo -e "cd $2/raw_data/$1\n" >> $1_STARmap.sbatch

# Unzip and run FastQC on raw reads, keep original  (not working)
#echo -e "gunzip $1_1.fq.gz" >> $1_STARmap.sbatch
#echo -e "gunzip $1_2.fq.gz" >> $1_STARmap.sbatch

# run FastQC on raw files
echo -e "
echo 'Starting FastQC'\n
fastqc $2/raw_data/$1/$1_1.fq
fastqc $2/raw_data/$1/$1_2.fq
echo 'Finished FastQC'\n" >> $1_STARmap.sbatch
 
# move cleaned files to working data dir
echo -e "mv *fast* $2/working_data/$1/\n" >> $1_STARmap.sbatch

# Run TrimGalore
echo -e "echo 'Starting trim_galore'
trim_galore --paired --phred33 --fastqc --illumina --dont_gzip -q 30 --length 30 $2/raw_data/$1/$1_1.fq $2/raw_data/$1/$1_2.fq --output_dir $2/working_data/$1
echo 'Finished trim_galore'\n" >> $1_STARmap.sbatch

# change to working data dir
echo -e "cd $2/working_data/$1\n" >> $1_STARmap.sbatch

# Re-load modules for STAR
echo -e "
module purge
. /etc/profile.d/user-default-modules.sh
module load foss/2018a
module load STAR/2.5.3a-foss-2018a
" >> $1_STARmap.sbatch

## Run STAR
echo -e "
echo 'Starting star\n'
STAR --runThreadN 16 --sjdbGTFfile $GTF --outSAMstrandField intronMotif --genomeDir $IDX --limitBAMsortRAM=40000000000 --readFilesIn $1_1_val_1.fq $1_2_val_2.fq --outSAMtype SAM --quantMode GeneCounts --outFileNamePrefix  $2/result/$1/$1_STARout \n
echo 'finished star'\n" >> $1_STARmap.sbatch

echo -e "echo 'finished'\n" >> $1_STARmap.sbatch

sbatch $1_STARmap.sbatch

