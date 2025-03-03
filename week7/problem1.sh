r

# Read the file (assuming tab-delimited)
mytab <- read.delim("RNAseq.samcode.txt", header = TRUE, sep = "\t")

# Subset and filter the data using base R
mytab2 <- subset(mytab, 
  RILcode %in% c(21148, 21286, 22162, 21297, 21029, 22052, 22031, 21293, 22378, 22390) &
  TissueCode %in% c("B", "E") &
  Replicate == "0",
  select = c("RILcode", "TissueCode", "Replicate", "FullSampleName")
)

# View the resulting table
print(mytab2)
