#!/bin/bash
#SBATCH --job-name=evm
#SBATCH --mail-type=ALL
#SBATCH --mail-user=tpsylvst@memphis.edu
#SBATCH --partition=shortq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=180G
#SBATCH --time=3-00:00:00
#SBATCH --error=err.evm.log
#SBATCH --output=out.evm.log

# load python
module load python/3.9.13/gcc.8.2.0

# source conda module
source /cm/shared/public/apps/miniconda/3.7/etc/profile.d/conda.sh

# set variables
species=Chrysina_gloriosa
proteindb=/home/scratch/tpsylvst/databases/Arthropod-protein-db/proteins.fasta
cpu=${SLURM_CPUS_PER_TASK}
software_DIR=/home/scratch/tpsylvst/software
project_DIR=/home/scratch/tpsylvst/projects/$species
script_DIR=$(pwd)
email=tpsylvst@memphis.edu
gtf2gff=/home/scratch/tpsylvst/software/Augustus/scripts/gtf2gff.pl
assembly=$project_DIR/assembly/$species.assembly.fa

# change working dir
# mkdir -p $project_DIR/genome-annotation-evm-test/evm
cd /home/scratch/tpsylvst/projects/Chrysina_gloriosa/evm-test

# copy gtf files to working dir
cp $project_DIR/.deprecated/genome-annotation-RM/braker-abinitio/round_1/augustus.ab_initio.gtf ./braker.abinitio.gtf
cp $project_DIR/.deprecated/genome-annotation-RM/braker-protein/round_1/augustus.hints.gtf ./braker.protein.gtf
cp $project_DIR/genome-annotation/ProtHint/Spaln/spaln.gff ./

# convert braker outputs into evm format
$software_DIR/TSEBRA-exp/bin/braker2evm_format.py \
--braker1 braker.abinitio.gtf \
--braker2 braker.protein.gtf \
--evm $software_DIR/EVidenceModeler-v2.0.0/ \
--out braker.evm.gff3

# activate BRAKER environment
conda activate /home/scratch/tpsylvst/conda-env/Braker2

# convert splain output to evm format and get top hits only
$software_DIR/TSEBRA-exp/bin/topProt2hints.py \
--topProts spaln.gff \
--evm_out evm_protein.gff \
--braker_out braker_protein.gff

# activate EVM environment
conda deactivate
conda activate /home/scratch/tpsylvst/conda-env/pasa

# set the weights for evm
echo -e \
"ABINITIO_PREDICTION\tAugustus\t2
ABINITIO_PREDICTION\tBraker2\t5
PROTEIN\tSpaln_scorer\t5" > weights.txt

echo "$assembly"

# run EVidenceModler
/home/scratch/tpsylvst/software/EVidenceModeler-v2.0.0/EVidenceModeler \
--sample_id $species \
--weights weights.txt \
--genome $assembly \
--gene_predictions braker.evm.gff3 \
--protein_alignments evm_protein.gff \
--segmentSize 1000000 \
--overlapSize 200000 \
--CPU $cpu

# load busco
module load busco/3.8.7

# run busco on annotation with protein homology
busco -i $species.EVM.pep -o $species.EVM.pep.busco -m prot -c $cpu -l endopterygota_odb10 -f;

# email busco updates
cat $species.EVM.pep.busco/s* | mail -s "$species EVM busco" $email;
