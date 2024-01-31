#!/bin/bash

blastn \
-query ../../11.nuclear-only-assembly/2.post-polishing/cglo-nuclear-genome.fasta \
-db ../../4.blast/BlastDB/NCBI-nt/nt \
-outfmt '6 qseqid staxids bitscore std' \
-max_target_seqs 10 \
-max_hsps 1 \
-out blast.out \
-num_threads 50