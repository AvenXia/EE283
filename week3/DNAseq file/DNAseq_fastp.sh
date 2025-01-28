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

less dna_file.txt |while read id;
do 
fastp -i rawdata/${id}_1.fq.gz -o ./fastp/${id}_1.fq.gz -I rawdata/${id}_2.fq.gz -O ./fastp/${id}_2.fq.gz -L
done

less dna_file.txt |while read id;
do 
fastqc fastp/${id}_1.fq.gz -o fastp/fastqc_fastp
fastqc fastp/${id}_2.fq.gz -o fastp/fastqc_fastp
done