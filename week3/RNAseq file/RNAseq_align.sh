#!/usr/bin/env bash

#SBATCH --job-name=test
#SBATCH -A CLASS-ECOEVO283
#SBATCH -p standard
#SBATCH --array 1-10
#SBATCH --cpus-per-task=2 
#SBATCH --error=log/slurm-%A_%a.log
#SBATCH --output=log/slurm-%A_%a.log

module load hisat2/2.2.1
module load samtools/1.15.1

cd ~/EE283/SEQDATA/RNAseq/rawdata

# make pathes
ref=~/EE283/SEQDATA/RNAseq/reference/dm6_trans
prefix_file=prefixes.txt

# get file prefix
prefix=$(head -n $SLURM_ARRAY_TASK_ID $prefix_file | tail -n 1) 

hisat2 -p 2 -x $ref -1 ${prefix}_R1.fastq.gz -2 ${prefix}_R2.fastq.gz | samtools view -bS - > ${prefix}.bam 
samtools sort ${prefix}.bam -o ${prefix}.sorted.bam 
samtools index ${prefix}.sorted.bam 
rm ${prefix}.bam  

