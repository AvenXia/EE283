options(future.globals.maxSize = 4000 * 1024 ^ 2)
library(Seurat)
library(ggplot2)
library(dplyr)
library(patchwork)
library(sctransform)
Rb.genes_total <- c('Rpsa', 'Rps2', 'Rps3', 'Rps3a', 'Rps4x', 
                    'Rps5', 'Rps6', 'Rps7', 'Rps8', 'Rps9', 
                    'Rps10', 'Rps11', 'Rps12', 'Rps13', 'Rps14', 
                    'Rps15', 'Rps15a', 'Rps16', 'Rps17', 'Rps18', 
                    'Rps19', 'Rps20', 'Rps21', 'Rps23', 'Rps24', 
                    'Rps25', 'Rps26', 'Rps27', 'Rps27a', 'Rps28', 
                    'Rps29', 'Rps30', 'Rpl3', 'Rpl4', 'Rpl5', 
                    'Rpl6', 'Rpl7', 'Rpl7a', 'Rpl8', 'Rpl9', 
                    'Rpl10', 'Rpl10a', 'Rpl11', 'Rpl12', 'Rpl13', 
                    'Rpl13a', 'Rpl14', 'Rpl15', 'Rpl17', 'Rpl18', 
                    'Rpl18a', 'Rpl19', 'Rpl21', 'Rpl22', 'Rpl23', 
                    'Rpl23a', 'Rpl24', 'Rpl26', 'Rpl27', 'Rpl27a', 
                    'Rpl28', 'Rpl29', 'Rpl30', 'Rpl31', 'Rpl32',
                    'Rpl34', 'Rpl35', 'Rpl35a', 'Rpl36', 'Rpl44', 
                    'Rpl37', 'Rpl37a', 'Rpl38', 'Rpl39', 'Rpl40', 
                    'Rpl41', 'Rplp0', 'Rplp1', 'Rplp2')
Hb.genes_total <- c("Hba-a1", "Hba-a2", "Hba-x", "Hba-ps4", "Hba-ps3", 
                    "Hbb-y", "Hbb-bs", "Hbb-bt", "Hbb-bh1", "Hbb-bh2", 
                    "Hbb-bh3", "Hbb-b1", "Hbb-b2", "Hbb-bh0", "Hbb-ar", 
                    "Hbq1a", "Hbq1b")

p40.counts <- Read10X("P40_20200606/filtered_feature_bc_matrix")
for (i in 1:13){
  number <- which(rownames(p40.counts) == mt[i])
  p40.counts <- p40.counts[-number, ]
}
p40 <- CreateSeuratObject(counts = p40.counts, project = "p40", min.cells = 3, min.features = 200)
p40
mt <- grep(pattern = "^mt-", x = rownames(x = p40@assays$RNA), value = TRUE)
p40[["percent.mt"]] <- PercentageFeatureSet(p40, pattern = "^mt-")
matchRb <- CaseMatch(search = Rb.genes_total, match = rownames(x = p40))
p40[["percent.Rb"]] <- PercentageFeatureSet(p40, feature = matchRb)
#QC
png("C:/Users/86152/Desktop/srtp/P40_20200606/QC_mtrmAFTER.png", width = 1800  , height = 600)
VlnPlot(p40, features = c("nFeature_RNA", "nCount_RNA", "percent.mt", "percent.Rb"), ncol = 4)
dev.off()
plot1 <- FeatureScatter(p40, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot1 
p40 <- subset(p40,subset = nFeature_RNA > 750 & nFeature_RNA < 7000 & percent.mt < 5 & nCount_RNA < 40000)
p40 <- subset(p40,subset = nFeature_RNA > 750 & nFeature_RNA < 7000 & nCount_RNA < 40000)
#SCtransform
qc1 <- SCTransform(p40subset, vars.to.regress = "percent.mt", verbose = FALSE)
qc <- RunPCA(qc1, features = VariableFeatures(object = qc1))
DimPlot(qc, reduction = "pca")
qc <- FindNeighbors(qc, dims = 1:30)
qc <- FindClusters(qc, resolution = 0.9)
qc <- RunUMAP(qc, dims = 1:30)
DimPlot(qc, reduction = "umap", label = TRUE)

# normalization
p40 <- NormalizeData(p40, normalization.method = "LogNormalize", scale.factor = 10000)
#identification of highly variable features
p40 <- FindVariableFeatures(p40, selection.method = "vst", nfeatures = 2000)
top10 <- head(VariableFeatures(p40), 10)
plot3 <- VariableFeaturePlot(p40)
plot4 <- LabelPoints(plot = plot3, points = top10, repel = TRUE)
plot3 + plot4
#scaling
all.genes <- rownames(p40)
p40 <- ScaleData(p40)
# perform linear dimensional reduction (PCA)
p40 <- RunPCA(p40, features = VariableFeatures(object = p40))
DimPlot(p40, reduction = "pca")
# identify dimension
ElbowPlot(p40)
# clustering
#pca
p40 <- FindNeighbors(p40, dims = 1:15)
p40 <- FindClusters(p40, resolution = 0.9)
#resolution = 0.8-1.2 if number > 1000??
head(Idents(p40),5)
#umap
p40 <- RunUMAP(p40, dims = 1:15)
png("C:/Users/86152/Desktop/srtp/P40_20200606/umap15.png", width = 600  , height = 600)
DimPlot(p40, reduction = "umap", label = TRUE)
dev.off()
#tSNE
p40 <- RunTSNE(p40, dims = 1:15)
png("C:/Users/86152/Desktop/srtp/P40_20200606/tsne15.png", width = 600  , height = 600)
DimPlot(p40, reduction = "tsne", label = TRUE)
dev.off()
#Featureplot
FeaturePlot(p40, features = "nFeature_RNA")
FeaturePlot(p40, features = "nCount_RNA")
FeaturePlot(p40, features = "percent.mt")
FeaturePlot(p40, features = "percent.Rb")

p40 <- subset(p40, subset = seurat_clusters != "8")
png("tsne/neuron15tsne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Snap25", "Syt1", "Camk2b", "Atp1a3"))
dev.off()
png("tsne/glutamate15sne.png", width = 1200  , height = 600)
FeaturePlot(qc, features = c("Slc17a6", "Slc17a7"))
dev.off()
png("tsne/GABA15sne.png", width = 1200  , height = 1200)
FeaturePlot(qc, features = c("Slc32a1", "Slc6a1","Gad1", "Gad2"))
dev.off()
png("tsne/astrocyte15tsne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Aqp4", "Mfge8", "Agt", "Islr"))
dev.off()
png("tsne/endothelial15tsne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Adgrf5",'Cldn5', 'Vtn', 'Slc38a5', 'Myh11'))
dev.off()
FeaturePlot(p40, features = "Chst1")
png("tsne/OPC15tsne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Pdgfra", "Cspg4", "Grm5","Lum"))
dev.off()
png("tsne/OL15sne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Klk6", "Apod","Pmp22", "Trf")) 
dev.off()
png("tsne/microglia15tsne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c('C1qa', 'Cx3cr1', 'Spi1', 'Tmem119')) 
dev.off()
png("tsne/pericyte15tsne.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Pdgfrb"))
dev.off()
png("C:/Users/86152/Desktop/srtp/P40_20200606/mylein OL10umap.png", width = 1200  , height = 1200)
FeaturePlot(p40, features = c("Mal", "Mog", "Plp1","Opalin", "Serinc5"))
dev.off()
FeaturePlot(p40, features = c("Pglyrp1"))
cell.type <- c("inhibitory neurons", "excitatory neurons", "oligodendrocytes", "inhibitory neurons", "oligodendrocytes", "excitatory neurons",
                     "inhibitory neurons", "excitatory neurons", "endothelial cells", "excitatory neurons", "Oligodendrocyte precursor cells", "astrocytes", "excitatory neurons", 
                "inhibitory neurons", "excitatory neurons", "pericytes", "microglia", "excitatory neurons", "inhibitory neurons", "Vascular smooth muscle cells", "excitatory neurons", "excitatory neurons" )
Idents(p40) <- "seurat_clusters"
names(cell.type) <- levels(p40)
p40 <- RenameIdents(p40, cell.type)
p40$cell.type <- Idents(p40)
png("tsne/tsne15celltype.png", width = 1200  , height = 1200)
DimPlot(p40, reduction = "tsne", pt.size = 0.5, label = TRUE)+ NoLegend()
dev.off()
#DGE analysis
ClusterMarker <- FindAllMarkers(p40, slot = "data", only.pos = T,
                                logfc.threshold = 0.25, min.pct = 0.1)
save(ClusterMarker, file="ClusterMarker_p40.RData")
ClusterMarker <- ClusterMarker[,c(7,1:6)]
write.csv(ClusterMarker,file = "ClusterMarker_.csv", row.names=F)
ClusterMarker <- mutate(ClusterMarker, D_pct = ClusterMarker$pct.1-ClusterMarker$pct.2)

#subset neuron clusters
p40subset <- subset(p40, idents = c("GABA1", "Glu1", "GABA2", "Glu2", "GABA3", "Glu3", "Glu4", "Glu5", "GABA4", "Glu6", "Glu7", "Glu8", "Glu9", "Glu10"))
#neurons cluster re-PCA
p40subset <- RunPCA(p40subset, features = VariableFeatures(object = p40subset))
DimPlot(p40subset, reduction = "pca")
# identify dimension
ElbowPlot(test.seu)
# clustering

p40subset <- FindNeighbors(p40subset, dims = 1:15)
p40subset <- FindClusters(p40subset, resolution = 1)
#??resolution = 0.8-1.2 if number > 1000??
head(Idents(p40subset),5)
#umap
p40subset <- RunUMAP(p40subset, dims = 1:15)
png("C:/Users/86152/Desktop/srtp/P40_20200606/umapsubset15.png", width = 600  , height = 600)
DimPlot(p40subset, reduction = "umap", label = TRUE)
dev.off()
#FeaturePlot
png("C:/Users/86152/Desktop/srtp/P40_20200606/neuronsub15umap.png", width = 1200  , height = 1200)
FeaturePlot(p40subset, features = c("Snap25", "Syt1", "Camk2b", "Atp1a3"))
dev.off()
png("C:/Users/86152/Desktop/srtp/P40_20200606/glutamatesub15umap.png", width = 1200  , height = 600)
FeaturePlot(p40subset, features = c("Slc17a6", "Slc17a7"))
dev.off()
png("C:/Users/86152/Desktop/srtp/P40_20200606/GABA15subumap.png", width = 1200  , height = 1200)
FeaturePlot(p40subset, features = c("Slc32a1", "Slc6a1","Gad1", "Gad2"))
dev.off()
#
cell.typesub <- c('GABA_1', 'Glu_1', 'GABA_2', 'Glu_2', 'Glu_3', 
                'Glu_4', 'GABA_3', 'Glu_5', 'GABA_4', 'GABA_5', 
                'Glu_6', 'Glu_7', 'Glu_8', 'GABA_6', 'Glu_9',
                'GABA_7', 'Glu_10', 'Glu_11','Glu_12','Glu_13','GABA_8')
Idents(p40subset) <- "seurat_clusters"
names(cell.typesub) <- levels(p40subset)
p40subset <- RenameIdents(p40subset, cell.typesub)
p40subset$cell.typesub <- Idents(p40subset)
p40subset$f1<-factor(p40subset@active.ident ,levels =c('GABA_1', 'GABA_2', 'GABA_3', 'GABA_4', 'GABA_5', 'GABA_6', 'GABA_7', 'GABA_8', 
                                                       'Glu_1', 'Glu_2', 'Glu_3', 'Glu_4', 'Glu_5', 
                                                       'Glu_6', 'Glu_7', 'Glu_8', 'Glu_9',
                                                       'Glu_10', 'Glu_11','Glu_12','Glu_13') )
DoHeatmap(sc_G,features = "Xkr4",group.by = 'f1')
F1 <- factor(p40subset$cell.typesub, levels = c('GABA_1', 'GABA_2', 'GABA_3', 'GABA_4', 'GABA_5', 'GABA_6', 'GABA_7', 'GABA_8', 
                                'Glu_1', 'Glu_2', 'Glu_3', 'Glu_4', 'Glu_5', 
                                'Glu_6', 'Glu_7', 'Glu_8', 'Glu_9',
                                'Glu_10', 'Glu_11','Glu_12','Glu_13'))


#neuronsubset markers
ClusterMarkersub <- FindAllMarkers(p40subset, slot = "data", only.pos = T,
                                logfc.threshold = 0.25, min.pct = 0.1)
save(ClusterMarkersub, file="ClusterMarker_p40sub.RData")
ClusterMarkersub <- ClusterMarkersub[,c(7,1:6)]
write.csv(ClusterMarkersub,file = "ClusterMarker_sub.csv", row.names=F)
png("cluster/cluster9.png", width = 600  , height = 600)
FeaturePlot(p40subset, features = "Meis2")
dev.off()
top15gene <- read.csv("ClusterMarker_subtop15.csv")
png("markerheatmapbian.png", width = 3600  , height = 1800)
DoHeatmap(p40subset, features = top15gene$gene, group.by = 'f1') + NoLegend()
dev.off()

