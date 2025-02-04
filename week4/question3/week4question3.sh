cd /dfs6/pub/qingyux3/SEQDATA/DNAseq
bamCoverage -b $A4 \
    -o deeptools/ADL06_1.coverage.bw \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM \


bamCoverage -b $A5 \
    -o deeptools/ADL09_1.coverage.bw \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM 



bamCompare -b1 $A4 -b2 $A5 \
 -o log2ratio.bw \
 --normalizeUsing RPKM --scaleFactorsMethod None\
 --region chrX:1880000:2000000 \
--binSize 1 

computeMatrix scale-regions \
    --scoreFileName ADL06_1.coverage.bw ADL09_1.coverage.bw \
    --regionsFileName ADL09_1.coverage.bedgraph \
    -b 3000 -a 3000 \
  --regionBodyLength 5000 \
  --skipZeros -o matrix2_multipleBW_l2r_twoGroups_scaled.gz \
  --outFileNameMatrix matrix2_multipleBW_l2r_twoGroups_scaled.tab \
  --outFileSortedRegions regions2_multipleBW_l2r_twoGroups_genes.bed
plotProfile -m matrix2_multipleBW_l2r_twoGroups_scaled.gz -out log2ratio.png

computeMatrix scale-regions \
    --scoreFileName log2ratio.bw \
    --regionsFileName ADL09_1.coverage.bedgraph \
    -b 5000 -a 5000 \
  --regionBodyLength 5000 \
  --skipZeros -o bamcompare_scaled.gz \
  --outFileNameMatrix bamcompare.tab \
  --outFileSortedRegions bamcompare.bed
plotProfile -m bamcompare_scaled.gz -out bamcompare.png