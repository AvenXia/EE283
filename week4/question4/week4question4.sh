bamCoverage -b $A4 \
    -o deeptools/ADL06_1.fragcoverage.bw \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM \
    --extendReads



bamCoverage -b $A5 \
    -o deeptools/ADL09_1.fragcoverage.bw \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM \
    --extendReads
 
bamCoverage -b $A5 \
    -o deeptools/ADL09_1.fragcoverage.bedgraph \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM \
    --extendReads \
    --outFileFormat bedgraph




bamCompare -b1 $A4 -b2 $A5 \
 -o log2ratiofrag.bw \
 --normalizeUsing RPKM --scaleFactorsMethod None\
 --region chrX:1880000:2000000 \
--binSize 1 \
    --extendReads


computeMatrix scale-regions \
    --scoreFileName ADL06_1.fragcoverage.bw ADL09_1.fragcoverage.bw \
    --regionsFileName ADL09_1.fragcoverage.bedgraph \
    -b 5000 -a 5000 \
  --regionBodyLength 5000 \
  --skipZeros -o fragmatrix2_multipleBW_l2r_twoGroups_scaled.gz \
  --outFileNameMatrix fragmatrix2_multipleBW_l2r_twoGroups_scaled.tab \
  --outFileSortedRegions fragregions2_multipleBW_l2r_twoGroups_genes.bed
plotProfile -m fragmatrix2_multipleBW_l2r_twoGroups_scaled.gz -out fraglog2ratio.png

computeMatrix scale-regions \
    --scoreFileName log2ratiofrag.bw \
    --regionsFileName ADL09_1.fragcoverage.bedgraph \
    -b 3000 -a 3000 \
  --regionBodyLength 5000 \
  --skipZeros -o fragbamcompare_scaled.gz \
  --outFileNameMatrix fragbamcompare.tab \
  --outFileSortedRegions fragbamcompare.bed
plotProfile -m fragbamcompare_scaled.gz -out fragbamcompare.png





 



