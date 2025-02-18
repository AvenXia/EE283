## _EE283 Week4_

Name: Qingyuan XIA
## Task1
Use samtools and the gDNA seq bam files to extract a 120kb region of the genome (chrX from 1,880,000 to 2,000,000) from strain “A4”. Make sure you only include reads that have mapq > 30.  Also do this for a control strain (A5).
## Answer1
Here we used samtools view to extract region that we want. For mapq > 30, we used parameter "-q 30". For region specific, we used region=X:1880000-2000000.
The code can be checked from question1/week4question1.sh
## Task2
Repeat the exercise of step #1 but instead extract reads mapping to different chromosomes whose mate maps to this region.  This means you cannot filter on quality score.  Extract them as fasta.  Then try to assemble using spades.  And figure out what is going on using blast.
## Answer2
We extracted F&R reads matching each ID, and filtered for reads NOT mapping to X ( sequence = candidates for repeats as the mate maps to X) 
The data is printed as fasta and aligned by spades.  
When we looked at contig.fa file, There are 11 nodes, where Node1 has a longer length while the others are short. The longer sequence (Node1) is matched to a long terminal repeats. The others are too short to match a sequence, which is hard for further GATK SNP analysis.

## Task3
Using deeptools and the bam files of problem 1, plot the per bp read coverage for your regions for the two samples (normalize using RPKM).  Try to visualize A4 relative to A5 (especially around 1,904,042).  
## Answer3
An environment with software "deeptools" is created for analysis. The coverage rate is calculated by function "bamcoverage", where the normalization method we used is RPKM. Then the signal value covered in specific region of the genome is calculated by computematrix. The function plotProfile can plot the coverage rate within specific regions.
The code can be checked from question3/week4question3.sh
## Task4
Repeat the process but plot the fragment coverage (--extendReads).  Try to visualize A4 vs. A5 (especially around 1,904,042).
## Answer4
The code is similar to question 3. The only difference is that we should include fragment coverage (--extendReads) in bamcompare function.
The code can be checked from question4/week4question4.sh
