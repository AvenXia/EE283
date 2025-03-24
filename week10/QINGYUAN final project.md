---
title: Final Porject: working through Seurat for single-cell/nuclei RNA sequencing data analysis
Name: Qingyuan Xia
---

# Introduction
The gene expression pattern is one of the significant markers representing the cellular states. The development of RNA sequencing makes it possible to reveal the whole transcriptome in the biological samples. The appearance of single cell/nuclei RNA sequencing reveals the cellular heterogeneity in the biological systems. To statistically analyze sn-RNA data, new packages such as Seurat were designed. In this final project, we are going to work out a tutorial of R package called Seurat, including quality control, data clustering and differential gene expression analysis. 

# Materials and Methods
## Raw data to be used
The datasets to be utilized is the single nuclei RNA sequencing data of a brain region, zona incerta, from one mouse at P40 stage at our lab.
## Upstream analysis by bash coding
To do the sequence assembly, annotation and gene counting of the raw data, the pipeline called Cell Ranger from 10X Genomics is applied. It can  perform sample demultiplexing, barcode processing, single cell 3' and 5' gene counting, V(D)J transcript sequence assembly and annotation, and Feature Barcode analysis from single cell data. Raw reads have been first mapped to the mm10 mouse reference genome and demultiplexed to generate a per-cell count matrix using CellRanger pipeline. By running cellranger count, we picked up "filtered_feature_bc_matrix" from the output dataset, which will be applied for downstream R analysis.
## Downstream analysis by R
The following downstream analysis is achieved by Seurat from R. The input data will be filtered_feature_bc_matrix by cell ranger. Cells of potentially low quality (unique feature counts > 7500 or total UMI < 700 or total UMI > 40,000, or percentage of mitochondrial genes > 10%) were removed from downstream analysis. 
### Identifying diverse types of cell populations across multiple datasets
Identifying the cell populations across multiple datasets from different mice brings about the unique problem because of experimental variations (batch effects and disease conditions). To minimize this, the reciprocal PCA method in Seurat package is utilized that projects each dataset into the others PCA space and constrains the anchors by the same mutual neighborhood requirement. Briefly, gene counts are normalized and 2000 highly variable genes are selected in each dataset based on the mean/variance calculations. The features that are repeatedly variable across datasets is selected for integration PCA. After each dataset is scaled and performed with PCA, anchors between individual data are identified for data integration. The integrated data is further scaled and centered followed by regular PCA on purpose of dimension reduction. PC1 to PC30 are chosen to construct a K-nearest neighbor (KNN) graph based on the euclidean distance in PCA space, and the edge weights between any two cells are modified based on Jaccard similarity. The cell clustering in the KNN graph is achieved by applying Louvain algorithm clustering (resolution = around 1). For microglia/neuron re-clustering, the clusters were extracted and then clustered based on the identical integrative clustering and DGE method mentioned above.
### Re-cluster the GABAergic neuron cluster and do differential gene expression analysis for each sub-cluster
To reveal the gene expression heterogeneity of GABAergic neurons in the brain region, the data cluster of inhibitory neurons is extracted, and re-clustered by PCA. The sub-clusters are visualized again by UMAP. The highly expressed genes in each cluster is performed by DGE methods.

# Results
Here we summarized all of the figures including quality control, clustering visualization and DGE analysis in a powerpoint slide, where you can read carefully through the whole logic story of the project. The name of the powerpoint is: Final project result summary.ppt

# Data presentation
The gene marker of each subcluster is listed in xsl file from "gabasubtop15".

# Script presentation
The R script is presented from "Final project script"