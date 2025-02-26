## _EE283 Week6_

Name: Qingyuan XIA
## Task1
Do QC on 6 of your ATACseq bam files.  Try to include the different tissue types.
## Answer1
For each ATACseq file, post-processing is done to remove mtDNA and PCR duplicates. Then we put the data in Rstudio to do QC. The fragment size peaks peaks correspond to different nucleosome occupancies, and the complexity plot is also good quality. Specifically to plot the density reading map, the seqdata should be re-aligned by UCSC database. By  plotting the density of reads mapping near TSSs that are nucleosome free and monocleosome, the figure conforms to what we saw in the lecture. 
## Task2
Generate a broad peaks bigwig for one of the 4 tissues (by combining samples within that tissue and running MACS2).  Try serving it up from cyverse (https://cyverse.org/; the free tier should be OK for this course), or some other option you have access to (e.g, your lab has a webserver, etc).
## Answer2
The handbook from the lecture is followed to run MACS2. We are looking on merged data of A5_tissue ED samples. After merging the data and then run MACS2, the sorted bam file is converted into bigwig file and visualized by UCSC database. There are ATAC seq peaks from chrX.
## Task3
Some people do not like the way MAC2/bigwig displays its broad peaks file.  So I propose rolling our own.  Start with a sorted indexed bam file, perhaps made by combining all the different genotypes within a tissue (or if you wish compare two genotypes).  Then we will just calculate read-span coverage throughout the genome.  I will normalize by the number of reads in the bam.
## Answer3
The code from the lecture is followed and we can also get the peaks of ATACseq. However, the peak levels are lower than the previous ones, showing lost of data from low signal regions.
## Task4
You could also explore the poorly documented -pc switch of genomeCoverageBed above.  What is this switch doing (is it clear from the documentation).  The “bamCoverage” tool from deeptools (of week 4) is perhaps more transparent, and can output directly to bigwig, and has some automatic switches for normalization, and has some extra switches that could be useful.  See if you can get additional coverage tracks using this tool (and check they are the same!).
## Answer4
The bamcoverage function from deeptools is applied here to check if it can also be used to study ATACseq peak. The bamcoverage can also show ATACseq peaks and the peak distribution is similar to that by BEDTOBIGWIG (problem2).
