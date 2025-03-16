# aligned samples' name
# 21148_B_0, 21148_E_0, 21286_B_0, 21286_E_0
# 22162_B_0, 22162_E_0, 21297_B_0, 21297_E_0
# 21029_B_0, 21029_E_0, 22052_B_0, 22052_E_0
# 22031_B_0, 22031_E_0, 21293_B_0, 21293_E_0
# 22378_B_0, 22378_E_0, 22390_B_0, 22390_E_0

```r
library(tidyverse)

data_dir = '/pub/qingyux3/EE283/SEQDATA/RNAseq/week7/rawdata'
out_dir = '/pub/qingyux3/EE283/SEQDATA/RNAseq/week7/problem1'
meta_path = file.path(data_dir, 'RNAseq384_SampleCoding.txt')
meta = read_tsv(meta_path)
meta


meta_2 <- meta[, c("RILcode", "TissueCode", "Replicate", "FullSampleName")]

# filter RILcode
ril_filter <- c(21148, 21286, 22162, 21297, 21029, 22052, 22031, 21293, 22378, 22390)
meta_2 <- subset(meta_2, RILcode %in% ril_filter)

# filter tissue code
meta_2 <- subset(meta_2, TissueCode %in% c("B", "E"))

# filter replicates
meta_2 <- subset(meta_2, Replicate == "0")

# save data
for(i in 1:nrow(meta_2)){
  file_name = paste(meta_2$RILcode[i], meta_2$TissueCode[i],
                    meta_2$Replicate[i], sep='_')
  file_name = paste('/pub/renl6/ee283/alignment/RNAseq/', file_name, '.sort.bam\n', sep='')
  cat(file_name, 
      file=file.path(out_dir, 'shortRNAseq.names.txt'), append=TRUE)
}

write_tsv(meta_2, file.path(out_dir, 'shortRNAseq.txt'))
```
Do feature count
```sh
#!/usr/bin/env bash

#SBATCH --job-name=ee283_hw7
#SBATCH -A CLASS-ECOEVO283
#SBATCH -p standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2  
#SBATCH --error=log/slurm-%J.log
#SBATCH --output=log/slurm-%J.log

# activate conda env
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basicbio

data_dir='/pub/qingyux3/EE283/SEQDATA/RNAseq/week7/problem1'
gtf='/pub/qingyux3/EE283/data/ref/dmel-all-r6.13.gtf'

# the program expects a space delimited set of files...
bam_names=`cat $data_dir/shortRNAseq.names.txt | tr "\n" " "`
featureCounts $bam_names -p -T 8 -t exon -g gene_id -Q 30 -F GTF -a $gtf -o $data_dir/fly_counts.txt
```