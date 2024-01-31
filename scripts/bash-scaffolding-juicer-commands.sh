## WORKING DIRECTORY 
cd /mnt/d/Terrence/projects/chrysina-gloriosa/Analysis/genome-assembly/15.scaffolding-3d-DNA

# activate conda env to get BWA
conda acitvate popgen

# juicer command to make input for 3d-DNA
./juicer/CPU/juicer.sh \
-s "none" \
-z reference-genome/cglo-nuclear-genome.fasta \
-t 40 \
-T 40 \
--assembly \
-D ./juicer/CPU/

# run 3d-DNA
../3d-DNA/run-asm-pipeline.sh ../reference-genome/cglo-nuclear-genome.fasta ../aligned/merged_nodups.txt

../software/3d-DNA/run-asm-pipeline.sh \
-m haploid \
-r 5 \
-q 30 \
--sort-output ../1.input-data/reference-genome/cglo-nuclear-genome.fasta \
../2.juicer-output/aligned/merged_nodups.txt

# reviev assembly in JBAT

# post review 
../software/3d-DNA/run-asm-pipeline-post-review.sh \
--sort-output \
-q 30 \
-r polished.assembly \
../1.input-data/reference-genome/cglo-nuclear-genome.fasta \
../2.juicer-output/aligned/merged_nodups.txt 