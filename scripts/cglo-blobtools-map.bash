#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=cglo-blobtools-map				#Job name
#SBATCH --time=5-00:00:00									#time to run the command in dd-hh:mm:ss format
#SBATCH --nodes=1											#number of nodes (computers)
#SBATCH --ntasks=1 											#number of commands to run
#SBATCH --cpus-per-task=25					 				#number of cpus each task can use
#SBATCH --mem=56G 											#memory per node
#SBATCH --output=cglo-blobtools-map-out.log							#save stdout to file
#SBATCH --error=cglo-blobtools-map-err.log								#save stderr to file

## OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                   #Send email on all job events
#SBATCH --mail-user=terrence@tamu.edu     #Send all emails to email_address 

# source anaconda profile
source /sw/eb/sw/Anaconda3/2021.05/etc/profile.d/conda.sh
# activate conda environment
conda activate /scratch/user/terrence/condaEnvs/python3/

# run minimap2
minimap2 -x map-ont -a -o ../5.blobtools/1.map/cglo-nuc-map.sam -t 25 ../11.nuclear-only-assembly/cglo-nd-nuclear.fasta ../../../../../RawData/Nanopore-seq/concatanated-seqs/filtered/size-filtered-seqs.fastq.gz


