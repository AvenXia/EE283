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
module load fastqc/0.11.9
mkdir fastqc
less atac_file.txt |while  read id;
do 
fastqc -t 12 rawdata/${id}_1.fq.gz -o fastqc
fastqc -t 12 rawdata/${id}_2.fq.gz -o fastqc
done