samtools view -q 30 -b P019_A5_ED_1.sort.bam chrX | samtools sort -O BAM - > merge/sample1.bam
samtools index merge/sample1.bam

samtools view -q 30 -b P020_A5_ED_2.sort.bam chrX | samtools sort -O BAM - > merge/sample2.bam
samtools index merge/sample2.bam

samtools view -q 30 -b P021_A5_ED_3.sort.bam chrX | samtools sort -O BAM - > merge/sample3.bam
samtools index merge/sample3.bam

# remove PCR duplicates (optional)
java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates \
-I merge/sample1.bam \
-O merge/sample1.dedup.bam \
-M merge/sample1.marked_dup_metrics.txt \
--REMOVE_DUPLICATES TRUE

java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates \
-I merge/sample2.bam \
-O merge/sample2.dedup.bam \
-M merge/sample2.marked_dup_metrics.txt \
--REMOVE_DUPLICATES TRUE

java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates \
-I merge/sample3.bam \
-O merge/sample3.dedup.bam \
-M merge/sample3.marked_dup_metrics.txt \
--REMOVE_DUPLICATES TRUE

samtools index sample1.dedup.bam
samtools index sample2.dedup.bam
samtools index sample3.dedup.bam

samtools merge -o condition1.bam sample1.dedup.bam sample2.dedup.bam sample3.dedup.bam
samtools index condition1.bam
module load bedtools2/2.30.0  
bedtools bamtobed -i condition1.bam | awk -F $'\t' 'BEGIN {OFS = FS}{ if ($6 == "+") {$2 = $2 + 4} else if ($6 == "-") {$3 = $3 - 5} print $0}' > condition1.tn5.bed
macs2 callpeak -t condition1.tn5.bed -n condition1 -f BED -g mm -q 0.01 --nomodel --shift -75 --extsize 150 --keep-dup all -B --broad

rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64.v369/ /dfs6/pub/qingyux3/SEQDATA/ATACseq/WEEK6/bamdata/merge/ucsctools

ucsctools/fetchChromSizes dm6 > mergedata/dm6.chrom.sizes
# move the resulting file to your ref folder
LC_COLLATE=C sort -k1,1 -k2,2n mergedata/condition1_treat_pileup.bdg > mergedata/broad_treat_pileup.sorted.bdg
awk 'NR==FNR {chr_size[$1] $2; next} $3 > chr_size[$1]' mergedata/dm6.chrom.sizes mergedata/broad_treat_pileup.sorted.bdg > mergedata/broad_treat_pileup.safeends.bdg
ucsctools/bedGraphToBigWig mergedata/broad_treat_pileup.safeends.bdg mergedata/dm6.chrom.sizes mergedata/broad_peaks.bw
