###########problem1################
library(ggplot2)
library(nycflights13)
library(patchwork)
flights
P1 <- ggplot(flights, aes(x=distance,y=arr_delay)) +
  geom_point() + 
  geom_smooth()

temp_flights <- flights %>%
  group_by(carrier) %>%
  summarize(m_arr_delay = mean(arr_delay,na.rm=TRUE))

P2 <- ggplot(temp_flights, aes(x=carrier,y= m_arr_delay)) +
  geom_bar(stat="identity")

P3 <- ggplot(flights, aes(x=carrier, y=arr_delay)) + 
  geom_boxplot()

P4 <- ggplot(flights, aes(x=arr_delay)) +
  geom_histogram()


png("patch.fig1.png", width = 7, height = 6, units="in", res = 600)
(P1 | P2) / (P3 | P4)
graphics.off()

Layout = '
AAAB
AAAC
AAAD
'
png("patch.fig2.png", width = 14, height = 12, units="in", res = 600)
P1 + P2 + P3 + P4 + plot_layout(design = Layout) + plot_annotation(tag_levels = 'A')
graphics.off()

Layout = '
AAAB
AAAC
AAAD
'
png("patch.fig3.png", width = 14, height = 12, units="in", res = 600)
P1 + P2 + P3 + P4 + plot_layout(design = Layout) + plot_annotation(tag_levels = 'A')
graphics.off()
###########problem2################
library("ATACseqQC")
library("Rsamtools")
library("ggplotify")
p4 <- fragSizeDist(bamfile, bamfile.labels)
p4 <- data.frame(fragSizeDist(bamfile, bamfile.labels))
P4 <- ggplot(p4,aes(x=ATAC.chrX3.Var1, y=ATAC.chrX3.Freq))+geom_boxplot()+
  geom_point() + 
  geom_smooth()
p5 <- estimateLibComplexity(readsDupFreq(bamfile, index=bamfile))
P5 <- ggplot(p5,aes(x=reads, y=values))+
  geom_point() + 
  geom_smooth()
p6 <- featureAlignedHeatmap(sigs.log2, reCenterPeaks(TSS, width=ups+dws), zeroAt=.5, n.tile=NTILE)
P6.1 <- p6[[1]][["children"]][["raster.heatmap.NucleosomeFree"]]
P6.2 <- p6[[2]][["children"]][["raster.heatmap.mononucleosome"]]

lay <- rbind(c(1,1,1,4,4,4),
             c(1,1,1,4,4,4),
             c(2,2,2,3,3,3),
             c(2,2,2,3,3,3))
png("problem2ATAC.png", width = 12, height = 12, units="in", res = 600)
grid.arrange(P4,P5,P6.1,P6.2)
graphics.off()
###########problem3################
install.packages("qqman")
library(qqman)
p1 <- read_tsv("problem1table.txt")
library(tidyverse)
p1 = p1 %>% mutate(SNP=str_c(chr,pos,sep = "_"))
levels(as.factor(p1$chr))
p1 = p1 %>% mutate(CHR = as.numeric(factor(chr)))
p1 = p1 %>% mutate(P = 10^-logp_interaction)
p1 = p1 %>% mutate(BP = pos)
p1.1 <- manhattan(p1, chr = "CHR", bp = "pos", p = "P", snp = "SNP", col = c("gray10", "gray60"),
          chrlabs = NULL,
          suggestiveline = -log10(1e-02),
          genomewideline = -log10(1e-01), annotatePval =TRUE)


p2 <- read_tsv("problem2table.txt")
library(tidyverse)
p2 = p2 %>% mutate(SNP=str_c(chr,pos,sep = "_"))
levels(as.factor(p2$chr))
p2 = p2 %>% mutate(CHR = as.numeric(factor(chr)))
p2 = p2 %>% mutate(P = 10^-logp_independent)
p2 = p2 %>% mutate(BP = pos)

p1.2 <- manhattan(p2, chr = "CHR", bp = "pos", p = "P", snp = "SNP", col = c("gray10", "gray60"),
          chrlabs = NULL,
          suggestiveline = -log10(1e-05),
          genomewideline = -log10(5e-08), annotatePval= TRUE)


#############problem4#################
source("myManhattanFunction.R")
p1.2 <- myManhattan(p1)
p2.2 <- myManhattan(p2)
#############problem5#################
p1$logp_independent <- p2$logp_independent
p3 <- ggplot(p1,aes(x=logp_interaction,y=logp_independent)) + geom_point(shape=19) +
  xlab("-logp_interaction") + ylab("-logp_independent")+geom_abline(slope = 1, intercept = 0)
library(gridExtra)
library(grid)
lay <- rbind(c(1,1,1,1,1,1,1,3,3,3,3,3,3),
             c(1,1,1,1,1,1,1,3,3,3,3,3,3),
             c(2,2,2,2,2,2,2,3,3,3,3,3,3),
             c(2,2,2,2,2,2,2,3,3,3,3,3,3))
png("problem5manhattan.png", width = 12, height = 6, units="in", res = 600)
grid.arrange(p1.2,p2.2,p3, layout_matrix = lay)
graphics.off()




grid.arrange(estimateLibComplexity(readsDupFreq(bamfile, index=bamfile)),estimateLibComplexity(readsDupFreq(bamfile, index=bamfile)))

