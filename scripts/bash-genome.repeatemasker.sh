#!/bin/bash
#SBATCH --job-name=CgloRMv2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=tpsylvst@memphis.edu
#SBATCH --partition=computeq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=180G
#SBATCH --time=28-00:00:00
#SBATCH --error=err.repeatemasker.log
#SBATCH --output=out.repeatemasker.log

# source conda module
source /cm/shared/public/apps/miniconda/3.7/etc/profile.d/conda.sh

# activate EDTA environment
conda activate /home/scratch/tpsylvst/conda-env/Repmodeler

# set variables
species=Chrysina_gloriosa
spDir=$(cd ../ && pwd)
scriptDir=$(pwd)
cpu=${SLURM_CPUS_PER_TASK}
pDIR=/home/scratch/tpsylvst/projects
software=/home/scratch/tpsylvst/software
assembly=$pDIR/$species/assembly/$species.assembly.fa

## Make working directory
# mkdir ../repeatmask-RM
cd ../repeatmask-RM

Rmod_dir=$(pwd)

## buld database for RepeatModeler
$software/RepeatModeler/BuildDatabase \
-name Cglo \
$assembly

## run RepeatModeler
$software/RepeatModeler/RepeatModeler \
-database Cglo \
-genomeSampleSizeMax 642274021 \
-threads $cpu \
-LTRStruct > run.out

mkdir RepeatMasker-cLib
cd RepeatMasker-cLib

# run RepeatMasker
$software/RepeatMasker/RepeatMasker \
-e rmblast \
-pa 10 \
-s \
-a \
-xsmall \
-gff \
-dir $(pwd) \
-lib $Rmod_dir/Cglo-custom-lib.fa \
$assembly

