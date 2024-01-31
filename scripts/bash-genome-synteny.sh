# map Tribolium and Chrysina
../../../../software/minimap2-2.24/minimap2 Tcas.fa.final Cglo.fa.final > Tcas_Cglo_minimap2.paf

# Make a links file from an alignment between the two genomes
../../linkify.sh -a Tcas_Cglo_minimap2.paf -l Tcas_Cglo_links.tsv

# 
../../../../software/circos-tools-0.23/tools/bundlelinks/bin/bundlelinks \
-links Tcas_Cglo_links.tsv \
-max_gap 5000000 \
-min_bundle_membership 4 > Tcas_Cglo_bundles.tsv

# repeat this with other genomes