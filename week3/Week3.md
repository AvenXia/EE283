## _EE283 Week3_

Name: Qingyuan XIA
## Task1
Take a pair (i.e., READ1 and READ2) gDNA paired end sequence files and run fastqc on it.  Run trimmomatic (or fastp) and rerun fastqc.  Describe anything interesting.  You have to run these via a sbatch command (or start an interactive hpc3 shell).
## Answer1
The fastqc file of The READ1 and READ2 from file ADL06_1 is obtained. Based on the score list in the fastqc file, the sequencing quality if good for both files. After trimming by fastp, both files are still good.
The code is listed from DNAseq_fastqc.sh and DNAseq_fastp.sh files
## Task2
So the same for a pair of ATACseq files
## Answer2
By doing fastqc, we found that the rawdata has part of adaptor sequence information from a longer distance of ATACseq, and this can be improved by fastp.
The code is listed from ATACseq_fastqc.sh and ATACseq_fastp.sh files

## Task3
Write a shell script submitted via sbatch to index your genomes
## Answer3
The code is listed from genome_index.sh file
## Task4
Align the DNAseq and ATACseq data to the genome.  You will need a slightly different shell script for each job … depending on how you have renamed your raw data.  If your names are an absolute disaster, just make new symlinks with better names.
## Answer4
To align the genome, the prefixes of each rawdata file is listed in one txt file. By using this prefixes file, we can do multiple tasks with 2 cpu core and use the function of bwa to do the alignment. samtool is applied to sort the data.
The file is listed from DNAseq_align.sh and ATACseq_align.sh
## Task5
Align the RNAseq data to the genome using a hisat2 pipeline.  You likely do NOT need to process all 384 samples (although the beauty of an array job is that you could).
## Answer5
The code is listed by RNAseq_align.sh
