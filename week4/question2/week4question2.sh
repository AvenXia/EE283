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
region="X:1880000-2000000"

samtools view -q 30 $A4 $region | cut -f1 > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2/A4.IDs.txt
samtools view -q 30 $A5 $region | cut -f1 > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2/A5.IDs.txt


samtools view $A4 | grep -F -f /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2/A4.IDs.txt | \
    awk '{if($3 != "X"){printf(">%s\n%s\n", $1, $10)}}' > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2/A4.fa
samtools view $A5 | grep -F -f /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2/A5.IDs.txt | \
    awk '{if($3 != "X"){printf(">%s\n%s\n", $1, $10)}}' > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2/A5.fa


cd /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p2
# cat A4.fa | grep ">" | wc -l
# wc -l A4.IDs.txt

python /data/homezvol0/qingyux3/miniforge3/envs/basic_biotools/bin/spades.py -o assembly/spades-default/ -s A4.fa --isolate > A4.messages.txt 
python /data/homezvol0/qingyux3/miniforge3/envs/basic_biotools/bin/spades.py -o assembly/spades-default/A5 -s A5.fa --isolate > A5.messages.txt 
