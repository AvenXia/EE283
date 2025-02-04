#!/bin/bash
#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=2  ## number of cores the job needs
#SBATCH --array=1-12       ## discussed more below
#SBATCH --error=test_%J.err
#SBATCH --output=test_%J.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue

cd /data/homezvol0/qingyux3/EE283/SEQDATA/ATACseq  
module load  bwa/0.7.17
module load samtools/1.15.1
ref="/data/homezvol0/qingyux3/EE283/SEQDATA/ATACseq/reference/dmel-all-chromosome-r6.13.fasta"
file="/data/homezvol0/qingyux3/EE283/SEQDATA/ATACseq/atac_file.txt"
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`
pathToRawData="/data/homezvol0/qingyux3/EE283/SEQDATA/ATACseq/rawdata"
pathToOutput="/dfs6/pub/qingyux3/SEQDATA/ATACseq/bam"
bwa mem -t 2 -M $ref $pathToRawData/${prefix}_R1.fq.gz $pathToRawData/${prefix}_R2.fq.gz | samtools view -bS - > $pathToOutput/${prefix}.bam
samtools sort $pathToOutput/${prefix}.bam -o $pathToOutput/${prefix}.sort.bam
samtools index $pathToOutput/${prefix}.sort.bam
  

