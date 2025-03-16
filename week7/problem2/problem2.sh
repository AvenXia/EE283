``` r
library( "DESeq2" )
library( "gplots" )
library( "RColorBrewer" )
library( "genefilter" )
library( "ggplot2" )

# read sample info
data_dir = '~/Code/test_R'
sampleInfo = read.table(file.path(data_dir, 'shortRNAseq.txt'), header=TRUE)
sampleInfo$FullSampleName = as.character(sampleInfo$FullSampleName)

# read count results
countdata = read.table(file.path(data_dir, 'fly_counts.txt'), header=TRUE, row.names=1)

# Remove first five columns (chr, start, end, strand, length)
countdata = countdata[ ,6:ncol(countdata)]

temp = colnames(countdata)
temp = gsub("X.pub.qingyux3.EE283.alignment.RNAseq.", "", temp)
temp = gsub(".sort.bam", "", temp)
temp = gsub("_", "", temp)
colnames(countdata) = temp

# create DEseq2 object & run DEseq
dds = DESeqDataSetFromMatrix(countData=countdata, colData=sampleInfo,
                             design=~TissueCode)
dds = DESeq(dds)
res = results( dds )
res


plotMA( res, ylim = c(-1, 1) )
plotDispEsts( dds )
hist( res$pvalue, breaks=20, col="grey" )

# log transform
rld = rlog( dds )
# this is where you could just extract the log transformed normalized data for each sample ID, and then roll your own analysis
head( assay(rld) )
mydata = assay(rld)
sampleDists = dist( t( assay(rld) ) )


# heat map
sampleDistMatrix = as.matrix( sampleDists )
rownames(sampleDistMatrix) = rld$TissueCode
colnames(sampleDistMatrix) = NULL
colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
heatmap.2( sampleDistMatrix, trace="none", col=colours)

# PCs, which can tell tissue apart
print( plotPCA( rld, intgroup = "TissueCode") )

# heat map with gene clustering
# these are the top genes (that tell tissue apart no doubt)
topVarGenes <- head( order( rowVars( assay(rld) ), decreasing=TRUE ), 35 )
heatmap.2( assay(rld)[ topVarGenes, ], scale="row", trace="none", dendrogram="column", col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255))

```
