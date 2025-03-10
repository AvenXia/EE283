#!/usr/bin/env bash

#SBATCH --job-name=test
#SBATCH -A CLASS-ECOEVO283
#SBATCH -p standard
#SBATCH --array 1-20
#SBATCH --cpus-per-task=2 
#SBATCH --error=test_%J.err
#SBATCH --output=test_%J.out

cd /dfs6/pub/qingyux3/SEQDATA/RNAseq/WEEK7
module load subread/2.0.3
# the gtf should match the genome you aligned to
# coordinates and chromosome names
gtf="/dfs6/pub/qingyux3/SEQDATA/RNAseq/reference2/dm6.ncbiRefSeq.gtf"
# the program expects a space delimited set of files...
myfile=`cat RNAseq/shortRNAseq.names.txt | tr "\n" " "`
featureCounts -p -T 8 -t exon -g gene_id -Q 30 -F GTF -a $gtf -o RNAseq/fly_counts.txt $myfile

R
library( "DESeq2" )
sampleInfo = read.table("shortRNAseq.txt")
sampleInfo$FullSampleName = as.character(sampleInfo$FullSampleName)

## I am assuming feature counts finished
countdata = read.table("fly_counts.txt", header=TRUE, row.names=1)
# Remove first five columns (chr, start, end, strand, length)
# or do it the tidy way
countdata = countdata[ ,6:ncol(countdata)]
# Remove crap from colnames in countdata
temp = colnames(countdata)
temp = gsub("RNAseq.bam.","",temp)
temp = gsub(".bam","",temp)
colnames(countdata) = temp

##  does everything match up...
cbind(temp,sampleInfo$FullSampleName,temp == sampleInfo$FullSampleName)

# create DEseq2 object & run DEseq
dds = DESeqDataSetFromMatrix(countData=countdata, colData=sampleInfo, design=~TissueCode)
dds <- DESeq(dds)
res <- results( dds )
res

plotMA( res, ylim = c(-1, 1) )
plotDispEsts( dds )
hist( res$pvalue, breaks=20, col="grey" )
###  throw out lowly expressed genes?? ... I leave this as an exercise
###  add external annotation to "gene ids"
# log transform
rld = rlog( dds )
## this is where you could just extract the log transformed normalized data for each sample ID, and then roll your own analysis
head( assay(rld) )
mydata = assay(rld)

sampleDists = dist( t( assay(rld) ) )
# heat map
sampleDistMatrix = as.matrix( sampleDists )
rownames(sampleDistMatrix) = rld$TissueCode
colnames(sampleDistMatrix) = NULL
library( "gplots" )
library( "RColorBrewer" )
colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
heatmap.2( sampleDistMatrix, trace="none", col=colours)
# PCs
# wow you can sure tell tissue apart
print( plotPCA( rld, intgroup = "TissueCode") )
# heat map with gene clustering
library( "genefilter" )
# these are the top genes (that tell tissue apart no doubt)
topVarGenes <- head( order( rowVars( assay(rld) ), decreasing=TRUE ), 35 )
heatmap.2( assay(rld)[ topVarGenes, ], scale="row", trace="none", dendrogram="column", col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255))
