# RNAseq HPC parallel submission
Bash scripts designed to submit and process multiple raw RNA libraries for RNAseq analysis in parallel

## Initial directory setup:
<PWD>/raw_data

## Contains 4 scripts:

## 0) Generate raw file list.txt
### Input: /raw_data, .fq files | Output: list.txt
Script that will generate list of .fq files that are stored in raw_data

## 1) Submission script
### Input: list.txt, 02_.sbatch
Submission script will create a unique sbatch code for each pair of read files and submit to the Slurm HPC

## 2) Excecution script
### Input: Pre-assmbled genome index, GTF, and raw genome file | Output: Cleaned, mapped RNAseq reads
Excecutes multiple software commands to analyze library contents, trim, clean, and map RNAseq files
0) FastQC - raw quality analysis
1) TrimGalore - clean and trim reads
2) FastQC - clean quality analysis
3) STAR alignment - map reads
*4) Counts files also generate by STAR. Need to add Kallisto for transcript counts

## 3) MultiQC
### Input: statitics summaries of FastQC and STAR | Output: .html report of all analysis
Gathers all relevant data into a new MultiQC folder, and performs analysis of all relevant data
