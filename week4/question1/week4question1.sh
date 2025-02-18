#!/bin/bash
#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=2  ## number of cores the job needs
#SBATCH --array=1-4       ## discussed more below
#SBATCH --error=test_%J.err
#SBATCH --output=test_%J.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue


module load samtools/1.15.1
module load bedtools2/2.30.0

A4="/dfs6/pub/qingyux3/SEQDATA/DNAseq/SNP/ADL06.sort.bam" 
A5="/dfs6/pub/qingyux3/SEQDATA/DNAseq/SNP/ADL09.sort.bam" 
A4_merge_extracted="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p1/A4_extracted.bam"
A5_merge_extracted="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p1/A5_extracted.bam"  
region="X:1880000-2000000"

samtools view $A4 $region -bh -q 30 -o $A4_merge_extracted
samtools view $A5 $region -bh -q 30 -o $A5_merge_extracted
