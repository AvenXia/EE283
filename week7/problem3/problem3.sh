``` r
library( "DESeq2" )
library( "gplots" )
library( "RColorBrewer" )
library( "genefilter" )
library( "ggplot2" )

# volcano plot
# covert to dataframe
res_df <- as.data.frame(res)

# add significant labels
res_df$Significance <- "Not Significant"
res_df$Significance[res_df$padj < 0.05 & res_df$log2FoldChange > 1] <- "Upregulated"
res_df$Significance[res_df$padj < 0.05 & res_df$log2FoldChange < -1] <- "Downregulated"

ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = Significance)) +
  geom_point(alpha = 0.8, size = 1.5) +
  scale_color_manual(values = c("Downregulated" = "blue", "Not Significant" = "gray", "Upregulated" = "red")) +
  theme_minimal() +
  xlab("log2 Fold Change") +
  ylab("-log10 Adjusted P-value") +
  ggtitle("Volcano Plot of DESeq2 Results") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "black") 
```
