module load samtools/1.15.1
module load bedtools2/2.30.0

A4="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bam/ADL06_1.sort.bam" 
A5="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bam/ADL09_1.sort.bam"    
region="X:1880000-2000000"

samtools view -q 30 $A4 $region | cut -f1 > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/ADL06_1.IDs.txt
samtools view -q 30 $A5 $region | cut -f1 > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/ADL09_1.IDs.txt


samtools view $A4 | grep -F -f /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/ADL06_1.IDs.txt | \
    awk '{if($3 != "X"){printf(">%s\n%s\n", $1, $10)}}' > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/ADL06_1.fa
samtools view $A5 | grep -F -f /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/ADL09_1.IDs.txt | \
    awk '{if($3 != "X"){printf(">%s\n%s\n", $1, $10)}}' > /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/ADL09_1.fa


cd /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit
cat ADL06_1.fa ADL09_1.fa | grep ">" | wc -l
wc -l ADL06_1.IDs.txt ADL09_1.IDs.txt

python /data/homezvol0/qingyux3/miniforge3/envs/basic_biotools/bin/spades.py -o assembly/spades-default/ADL06_1 -s ADL06_1.fa --isolate > ADL06_1.messages.txt 
python /data/homezvol0/qingyux3/miniforge3/envs/basic_biotools/bin/spades.py -o assembly/spades-default/ADL09_1 -s ADL09_1.fa --isolate > ADL09_1.messages.txt 

cat assembly/spades-default/ADL06_1contigs.fasta
cat assembly/spades-default/ADL09_1contigs.fasta
