# make a custom blast database
makeblastdb \
-in 1.blast-db-inputs/tcas-mitochondria-genes.fasta \
-parse_seqids \
-blastdb_version 5 \
-title "tcasMitoGenes" \
-dbtype nucl \
-taxid 7070 \
-out 2.bast-db/tcasMitoGenes

# do blast
blastn \
-query ../path/assembly.fasta \
-out ../path/blast-out.txt \
-outfmt 6 \
-max_target_seqs 10 \
-evalue 1e-10 \
-db ../path/db-name \
-num_threads 6

# get the mitochondrial contig
subseq assembly.fasta sequences.txt > subseq.fasta

# make mitochondria
# map reads to mitochondrial contig
minimap2 \
-x map-ont \
-a \
-o ../9.mitochondrial-assembly/cglo-mito-map.sam \
-t 8 \
../9.mitochondrial-assembly/p.mit.fasta \
../../../../../RawData/Nanopore-seq/concatanated-seqs/filtered/size-filtered-seqs.fastq.gz

# get only mapped reads
samtools view -b -F 4 cglo-mito-map.sam > cglo-mito-map.bam
# remove spurious mappings
samtools view -b -q 30 cglo-mito-map.bam > cglo-mito-map-q30.bam
# convert bam to fastq
samtools bam2fq cglo-mito-map-q30.bam > cglo-mito-map-q30.fastq
# run unicycler 
unicycler -l cglo-mito-map-q30.fastq -o 3.assembly



