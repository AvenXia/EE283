## _EE283 Week6_

Name: Qingyuan XIA
## Task1
Fix the final figure so it looks good
## Answer1
My understanding of this question is to make plots of the final part of the lecture, which is patchwork. So I repeat patchwork with flight figs, and make two figures
## Task2
Make a 4 or 6 panel figure from some previous results.  A great one would be left-right paired fragments lengths and TSS enrichment plots for four ATACseq samples.
## Answer2
I first tried to directly use ATACQC based plot on grid arrange. However, the plot is not in the form of ggplot. Therefore, I first make my own QC plot based on ggplot and then arrange the panel by grid arrange.
## Task3
Make a two panel Manhattan plot for the two scans of the last week (the two malathion scans fitting slightly different models).  Are they more or less telling us the same thing?
## Answer3
The qqman package is utilized to make manhattan plots for two models. It showed that results and pvalue distribution are different between two models, though we do find several SNPs that are highly significant in both models.
## Task4
 Install a new package for making Manhattan plots that gives us plots as ggplot objects (https://github.com/alfonsosaera/myManhattan). Repeat the problem of question 3 to confirm that new software functions the same as qqman.  
## Answer4
The package mymanhattan can also plot manhattanplot, and the distribution and results are the same as qqman package.
## Task5
Now plot the -log10(p)’s from the two models against one another as a third panel (which could identify SNPs where the two models disagree with one another).  Since manhattan plots are better wide and short, and plots more square-like, try to make the figure layout look like this (you will need to use the new package "myManhattan"):
## Answer5
The p-p comparison plot is made by scatter plot, which can be set by ggplot function. To arrange three plots, we utilized gridarrange function to lay out the panels.