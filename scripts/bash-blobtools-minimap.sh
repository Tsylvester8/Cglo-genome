#!/bin/bash

../../../../software/minimap2/minimap2 \
-a \
-o ../2.map/cglo-blobtools-map.sam \
-x map-ont \
-t 2 \
../../11.nuclear-only-assembly/2.post-polishing/cglo-nuclear-genome.fasta \
../../../../Raw-data/Nanopore/concat/size-filtered/size-filtered-seqs.fastq.gz