
samtools merge -o condition1.bam sample1.dedup.bam sample2.dedup.bam sample3.dedup.bam
samtools index condition1.bam

module load samtools/1.15.1  
module load bedtools2/2.30.0  
module load ucsc-tools/v429

# count the total number of reads
# and create a scaling constant for each bam
ref="/dfs6/pub/qingyux3/SEQDATA/ATACseq/reference2/dm6.fa.gz"
chromsizes="/dfs6/pub/qingyux3/SEQDATA/ATACseq/WEEK6/bamdata/merge/mergedata/dm6.chrom.sizes"
Nreads=`samtools view -c -q 30 -F 4 mergedata/condition1.bam`
Scale=`echo "1.0/($Nreads/1000000)" | bc -l`
samtools view -b mergedata/condition1.bam | genomeCoverageBed -ibam - -g $ref -bg -scale $Scale > mergedata/problem3/sample_1.coverage
# these are the so called "kent-tools", useful for converting between various file types
bedGraphToBigWig mergedata/problem3/sample_1.coverage $chromsizes mergedata/problem3/sample_1.bw