SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/RNAseq"
DestDir="/data/homezvol0/qingyux3/EE283/problem2/RNAseq/rawdata"
File="RNAseq384_SampleCoding.txt"
while read p
do
   echo "${p}"
   sample=$(echo $p | cut -f1 -d " ")
   DataDir="$SourceDir/RNAseq384plex_flowcell01"
   READ1=$(find ${DataDir}/ -type f -iname "${sample}_*R1_001.fastq.gz")
   READ2=$(find ${DataDir}/ -type f -iname "${sample}_*R2_001.fastq.gz")
   ln -s "$READ1" "${DestDir}/${sample}_R1.fastq.gz"
   ln -s "$READ2" "${DestDir}/${sample}_R2.fastq.gz"

done < $SourceDir/$File

