cd /dfs6/pub/qingyux3/SEQDATA/DNAseq
samtools index /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p1/A4_extracted.bam
samtools index /dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p1/A5_extracted.bam

A4="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p1/A4_extracted.bam" 
A5="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bamedit/week4_p1/A5_extracted.bam" 
bamCoverage -b $A4 \
    -o deeptools/A4_extracted_coverage.bw \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM

bamCoverage -b $A5 \
    -o deeptools/A5_extracted_coverage.bw \
    --region X:1880000:2000000 \
    --binSize 1 \
    --normalizeUsing RPKM



data_dir=/dfs6/pub/qingyux3/SEQDATA/DNAseq/deeptools
A4_cover=$data_dir/A4_extracted_coverage.bw
A5_cover=$data_dir/A5_extracted_coverage.bw


# interesetd locus: 1904042, region range [1880000, 2000000]
echo "Generate bed file"
region_bed=$data_dir/regions.bed
echo -e "X\t1904042\t2000000" > $region_bed


echo "Extract region coverage info..."
computeMatrix reference-point -S $A4_cover $A5_cover -R $region_bed --referencePoint TSS -b 5000 -a 10000 -o $data_dir/region_matrix.gz
computeMatrix scale-regions -S $A4_cover $A5_cover -R $region_bed -b 2000 -a 2000 -m 50000 -o $data_dir/scale_region_matrix.gz

echo "plotting..."
plotProfile -m $data_dir/region_matrix.gz -o $data_dir/cover_profile.png --refPointLabel 1904Kb --samplesLabel A4 A5 --perGroup

plotHeatmap -m $data_dir/region_matrix.gz -o $data_dir/cover_heatmap.png --refPointLabel 1904Kb --samplesLabel A4 A5

plotProfile -m $data_dir/scale_region_matrix.gz -o $data_dir/scaleregion_cover_profile.png --refPointLabel 1904Kb --samplesLabel A4 A5 --perGroup

plotHeatmap -m $data_dir/scale_region_matrix.gz -o $data_dir/scaleregion_cover_heatmap.png --refPointLabel 1904Kb --samplesLabel A4 A5

echo "Done!"