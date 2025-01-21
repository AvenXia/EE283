SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/DNAseq"
DestDir="/data/homezvol0/qingyux3/EE283/problem2/DNAseq/rawdata"
File="$SourceDir/*"
for f in $FILES
do
   ff=$(basename $f)
   echo "Processing $ff file..."
   ln -s $SourceDir/$ff $DestDir/$ff
done

