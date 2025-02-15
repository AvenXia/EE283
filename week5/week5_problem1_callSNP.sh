#!/bin/bash
#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=2  ## number of cores the job needs
#SBATCH --array=1-4       ## discussed more below
#SBATCH --error=test_%J.err
#SBATCH --output=test_%J.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue

module load java/1.8.0
module load gatk/4.2.6.1 
module load picard-tools/2.27.1  
module load samtools/1.15.1
cd /dfs6/pub/qingyux3/SEQDATA/DNAseq
file="genotype_file.txt"
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`
pathTosortbam="/dfs6/pub/qingyux3/SEQDATA/DNAseq/bam"
pathToOutput="/dfs6/pub/qingyux3/SEQDATA/DNAseq/SNP"
samtools merge -o $pathToOutput/${prefix}.bam $pathTosortbam/${prefix}_1.sort.bam $pathTosortbam/${prefix}_2.sort.bam $pathTosortbam/${prefix}_3.sort.bam
samtools sort $pathToOutput/${prefix}.bam -o $pathToOutput/${prefix}.sort.bam
java -jar /opt/apps/picard-tools/2.27.1/picard.jar AddOrReplaceReadGroups \
I=$pathToOutput/${prefix}.sort.bam \
O=$pathToOutput/${prefix}.RG.bam \
RGID=${prefix} \
RGLB=lib1 \
RGPL=ILLUMINA \
RGPU=D109LACXX \
RGSM=${prefix}\
VALIDATION_STRINGENCY=LENIENT \
SORT_ORDER=coordinate

java -jar /opt/apps/picard-tools/2.27.1/picard.jar AddOrReplaceReadGroups \
I=$pathToOutput/${prefix}.sort.bam \
O=$pathToOutput/${prefix}.RG.bam \
RGID=${prefix} \
RGLB=lib1 \
RGPL=ILLUMINA \
RGPU=D109LACXX \
RGSM=${prefix}\
VALIDATION_STRINGENCY=LENIENT \
SORT_ORDER=coordinate

java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates \
-I $pathToOutput/${prefix}.RG.bam \
-O $pathToOutput/${prefix}.dedup.bam \
-M $pathToOutput/${prefix}_marked_dup_metrics.txt \
--REMOVE_DUPLICATES TRUE

samtools index $pathToOutput/${prefix}.dedup.bam

/opt/apps/gatk/4.2.6.1/gatk HaplotypeCaller -R $ref -I $pathToOutput/${prefix}.dedup.bam --minimum-mapping-quality 30 -ERC GVCF -O $pathToOutput/${prefix}.g.vcf.gz

/opt/apps/gatk/4.2.6.1/gatk CombineGVCFs -R $ref $(printf -- '-V %s ' *.g.vcf.gz) -O allsample.g.vcf.gz

...
#SBATCH --array=1-7 
...
mychr=`head -n $SLURM_ARRAY_TASK_ID chrome.names.txt | tail -n 1`

/opt/apps/gatk/4.1.9.0/gatk --java-options "-Xmx3g" GenotypeGVCFs \
-R $ref -V $pathToOutput/allsample.g.vcf.gz --intervals $mychr \
-stand-call-conf 5 -O $pathToOutput/result.${mychr}.vcf.gz

java -jar /opt/apps/picard-tools/2.27.1/picard.jar MergeVcfs \
$(printf 'I=%s ' result.*.vcf.gz) O=all_variants.vcf.gz