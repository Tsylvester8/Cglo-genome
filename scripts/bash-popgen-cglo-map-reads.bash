#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=Map-reads-to-reference 	#Job name
#SBATCH --time=7-00:00:00 			#time to run the command in dd-hh:mm:ss format
#SBATCH --nodes=1  					#number of nodes (computers)
#SBATCH --ntasks=1 					#number of commands to run
#SBATCH --cpus-per-task=45			#number of cpus each task can use
#SBATCH --mem=200G					#memory per node
#SBATCH --output=%x-out.log		#save stdout to file
#SBATCH --error=%x-err.log    #save stderr to file


## OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                   #Send email on all job events
#SBATCH --mail-user=terrence@tamu.edu     #Send all emails to email_address

# fixed parameters
threads=45
genome=../1.genomes/1.whole-genome/chrysina-gloriosa-genome.fasta
reads=../../../Rawdata/Illumina-seq-curated/1a.paired-reads/
dirFromRawDat=../../../Analysis/2.population-genetics

# load modules
module load GCC/11.2.0 SAMtools/1.14 BWA/0.7.17

# part 1 indexing genomes
# index genome using BWA index
bwa index $genome
# index genome using SAMtools faidx
samtools faidx $genome

echo "indexing complete"

# # make dir to stor sam and bam files
mkdir ../2.map-and-variant-call/1.sam
mkdir ../2.map-and-variant-call/2.bam

# # part 2 mapping reads
(cd $reads
	for i in $(ls -1 *_R1_001.fastq.gz | sed 's/\_R1_001.fastq.gz//')
 	do 
 	# map reads
 	 bwa mem -t $threads -o $dirFromRawDat/2.map-and-variant-call/1.sam/$i.sam $dirFromRawDat/1.genomes/1.whole-genome/chrysina-gloriosa-genome.fasta $i\_R1_001.fastq.gz $i\_R2_001.fastq.gz
 	# convert sam to bam
 	samtools view -@ $threads -O BAM -o $dirFromRawDat/2.map-and-variant-call/2.bam/$i.bam $dirFromRawDat/2.map-and-variant-call/1.sam/$i.sam
 	# remove sam file to save space
 	rm $dirFromRawDat/2.map-and-variant-call/1.sam/$i.sam
 	done)

echo "mapping reads to the genome complete"

# # part 3 get unmapped reads
 (cd ../2.map-and-variant-call/2.bam/
 	for i in $(ls -1 *.bam| sed 's/\.bam//')
 	do 
 		echo $i
  		# get un-mapped reads
  		samtools view -@ $threads -f 4 -o ../../../1.genome-assembly/3.Y-chromosome-assembly/2.bam/unmapped_reads_$i.bam $i.bam
  	done)
 echo "isolating unmapped reads complete"

# part 4 sorting reads
(cd ../2.map-and-variant-call/2.bam/
 	for i in $(ls -1 *.bam| sed 's/\.bam//')
 	do 
 		echo $i
  		# sort mapped reads
  		samtools sort -n -o name-sorted-$i.bam -@ $threads $i.bam
  		# remove unsorted bam files
  		rm $i.bam
  	done)

# # rename bam file name
(cd ../2.map-and-variant-call/2.bam/ && rename name-sorted- "" *.bam)

echo "name sorting complete"

# part 5 fix mates
(cd ../2.map-and-variant-call/2.bam/
 	for i in $(ls -1 *.bam| sed 's/\.bam//')
 	do
 		# fix mates
 		samtools fixmate -@ $threads -m --reference ../$genome $i.bam mates-fixed-$i.bam
 		# remove old bam files
 		rm $i.bam
 	done)

# rename bam file name
(cd ../2.map-and-variant-call/2.bam/ && rename mates-fixed- "" *.bam)

echo "fixing mates complete"

# part 6 corrdinate sort 
(cd ../2.map-and-variant-call/2.bam/
	for i in $(ls -1 *.bam| sed 's/\.bam//')
	do
	 	# coord sort
 		samtools sort -@ $threads -o co-sorted-$i.bam $i.bam
 		# remove old bam files
 		rm $i.bam
	done)  

# rename bam file name
(cd ../2.map-and-variant-call/2.bam/ && rename co-sorted- "" *.bam)
  
echo "coordinate sorting complete"

# make new directory to store stats
mkdir ../2.map-and-variant-call/3.stats
mkdir ../2.map-and-variant-call/3.stats/1.markdup
mkdir ../2.map-and-variant-call/3.stats/2.coverage
	  
# part 7 remove PCR duplicates	  
(cd ../2.map-and-variant-call/2.bam/
	for i in $(ls -1 *.bam| sed 's/\.bam//')
 	do
	 	# remove PCR duplicates
 		samtools markdup -r -s -f ../3.stats/1.markdup/$i.txt -O BAM -@ $threads $i.bam dedup-$i.bam
	 	# remove old bam files
 		rm $i.bam
 		# get coverage of the bam reads 
	 	samtools coverage -o ../3.stats/2.coverage/$i.txt --reference ../$genome dedup-$i.bam 
 		# sort bam files
 		samtools sort -@ $threads -o $i.bam dedup-$i.bam
 		# remove old bam files
 		rm dedup-$i.bam
 		# index bam file
 		samtools index -@ $threads $i.bam
 	done)

echo "removal of PCR duplicates complete"

# part 8 filter and index bam

# make directory to store results
mkdir ../2.map-and-variant-call/4.bam-mapq30

# make new directory to store stats
mkdir ../2.map-and-variant-call/3.stats/3.coverage-mapq30

# part 1 filter for map quality and keep only mapped reads 
(cd ../2.map-and-variant-call/2.bam/
	for i in $(ls -1 *.bam| sed 's/\.bam//')
	do
	 	# filter based on map-quality
		samtools view -@ $threads -F 4 -q 30 -o ../4.bam-mapq30/mapq30_$i.bam $i.bam
 		# get coverage of the bam reads 
	 	samtools coverage -o ../3.stats/3.coverage-mapq30/$i.txt --reference ../$genome ../4.bam-mapq30/mapq30_$i.bam
 		# index bam file
 		samtools index -@ $threads ../4.bam-mapq30/mapq30_$i.bam
	done)  

# remove leading trm from all files
(cd ../2.map-and-variant-call/2.bam/ && rename trm "" *.bam)
(cd ../2.map-and-variant-call/2.bam/ && rename trm "" *.bai)

echo "filtering complete"

# part 9 rename bam and index files
(cd ../2.map-and-variant-call/2.bam/ && ../../0.scripts/cglo-rename-bam.bash)
(cd ../2.map-and-variant-call/2.bam/ && ../../0.scripts/cglo-rename-bai.bash)

# part 10 call variants
# purge loaded modules
module purge

# fixed parameters
info=AD,ADF,ADR,DP,SP,SCR,INFO/AD,INFO/ADF,INFO/ADR,INFO/SCR
# load BCFtools and dependencies
module load GCC/11.2.0 BCFtools/1.14

# make dir to store variants
mkdir ../2.map-and-variant-call/5.variants
mkdir ../2.map-and-variant-call/5.variants/1.all-indivs
mkdir ../2.map-and-variant-call/5.variants/1.all-indivs/1.unfiltered

# call variants
(cd ../2.map-and-variant-call/4.bam-mapq30/ && \
# call variants 
bcftools mpileup -f $genome -q 30 -Q 20 --skip-indels \
-a $info --threads $threads *.bam | bcftools call -m -v \
--threads $threads --skip-variants indels --output-type b \
-o ../5.variants/1.all-indivs/1.unfiltered/draft_gloriosa_q30Q20.bcf)

# call variants and indels
(cd ../2.map-and-variant-call/4.bam-mapq30/ && \
# call variants 
bcftools mpileup -f $genome -q 30 -Q 20 --skip-indels \
-a $info --threads $threads *.bam | bcftools call -m -v \
--threads $threads --output-type b \
-o ../5.variants/1.all-indivs/1.unfiltered/draft_gloriosa_q30Q20_with_indels.bcf)
