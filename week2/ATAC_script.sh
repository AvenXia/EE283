SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/ATACseq"
DestDir="/data/homezvol0/qingyux3/EE283/SEQDATA/ATACseq/rawdata"
File="/data/homezvol0/qingyux3/EE283/SEQDATA/ATACseq/rawdata/ATACseq.labels.txt "
while read p
do
   echo "${p}"
   barcode=$(echo $p | cut -f1 -d" ")
   genotype=$(echo $p | cut -f2 -d" ")
   tissue=$(echo $p | cut -f3 -d" ")
   bioRep=$(echo $p | cut -f4 -d" ")
   READ1=$(find ${SourceDir}/ -type f -iname "*_${barcode}_*R1.fq.gz")
   READ2=$(find ${SourceDir}/ -type f -iname "*_${barcode}_*R2.fq.gz")
   ln -s "$READ1" "${DestDir}/${barcode}_${genotype}_${tissue}_${bioRep}_R1.fq.gz"
   ln -s "$READ2" "${DestDir}/${barcode}_${genotype}_${tissue}_${bioRep}_R2.fq.gz"

done < $File